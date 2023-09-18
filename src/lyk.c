#define USE_YK
#define LYK_DEBUG
#ifdef USE_YK

#include "lyk.h"
#include "lobject.h"
#include "lopcodes.h"
#include "ldebug.h"
#include <stdlib.h>
#include <yk.h>
#include "stdio.h"
/*
 *  Function prototypes in Lua are loaded through two methods:
 *    1.  They are loaded from text source via the `luaY_parser`.
 *    2.  They can also be loaded from binary representation using `luaU_undump`, where
 *        prototypes are previously dumped and saved.
 *
 *  Yk tracing locations are allocated using both of these methods
 *  using `yk_set_location` and `yk_set_locations` respectively.
 */

#ifdef LYK_DEBUG
static int LYK_VERBOSE = -1;

int is_verbose() {
  if (LYK_VERBOSE == -1) {
    LYK_VERBOSE = getenv("LYK_VERBOSE") != NULL;
  }
  return LYK_VERBOSE;
}

void print_proto_info(char *msg, Proto *f) {
  if (!is_verbose()){
    return;
  }
  char *source = NULL;
  if (f->source != NULL) {
    source = getstr(f->source);
  }
  char *vars = NULL;
  if (f->locvars != NULL && f->locvars->varname != NULL) {
    vars = getstr(f->locvars->varname);
  }
  printf("[LYK] %s. \t f:\t%p \t source: %s: \t vars: %s", msg, f, source, vars);
  if (f->yklocs != NULL) {
    printf("\t sizecode: %d", f->sizecode);
    for (int i = 0; i < f->sizecode; i++) {
        printf("[LYK] %p->yklocs[%d]=%p\n", f, i, f->yklocs[i]);
    }
  }
  printf("\n");
}
#endif // LYK_DEBUG

void yk_on_newproto(Proto *f) {
  #ifdef LYK_DEBUG
  if (is_verbose()) {
    printf("[LYK] yk_new_proto %p\n", f);
    // print_proto_info("yk_new_proto", f0)
  }
  #endif // LYK_DEBUG
  f->yklocs = NULL;
}

/*
 *  Is the instruction `i` the start of a loop?
 *
 *  YKFIXME: Numeric and Generic loops can be identified by `OP_FORLOOP` and `OP_TFORLOOP` opcodes.
 *  Other loops like while and repeat-until are harder to identify since they are based on
 *  `OP_JMP` instruction.
 */
int is_loop_start(Instruction i) {
  return (GET_OPCODE(i) == OP_FORLOOP || GET_OPCODE(i) == OP_TFORLOOP);
}

inline YkLocation *yk_lookup_ykloc(CallInfo *ci, Instruction *pc) {
  YkLocation *ykloc = NULL;
  
  lua_assert(isLua(ci));
  Proto *p = ci_func(ci)->p;
  lua_assert(p->code <= pc && pc <= p->code + p->sizecode);
  if (is_loop_start(*pc)) {
    ykloc = p->yklocs[pc - p->code];
    if (is_verbose()) {
      printf("[LYK] yk_lookup_ykloc %p->ykloc[%ld]=%p at: %ld\n", p, pc - p->code, ykloc);
      for (int i = 0; i < p->sizecode; i++) {
        // if (p->ykloc[i] == NULL){}
        printf("[LYK] %p->yklocs[%d]=%p\n", p, i, p->yklocs[i]);
      }
    }
  }
  return ykloc;
}

void set_location(Proto *f, int i) {
  YkLocation *loc = (YkLocation *)malloc(sizeof(YkLocation));
  lua_assert(loc != NULL && "Expected loc to be defined!");
  *loc = yk_location_new();
  f->yklocs[i] = loc;
  #ifdef LYK_DEBUG
  if (is_verbose()){
    printf("[LYK] set_location. %p->yklocs[%d]=%p\n", f, i, loc);
    // print("set_location", f);
  }
  #endif // LYK_DEBUG
}

inline void yk_on_instruction_loaded(Proto *f, Instruction i, int idx) {
  // YKOPT: Reallocating for every instruction is inefficient.
  YkLocation **new_locations = calloc(f->sizecode, sizeof(YkLocation *));
  lua_assert(new_locations != NULL && "Expected yklocs to be defined!");
  
  // copy previous locations over
  if (f->yklocs != NULL) {
    for (int i = 0; i < f->yklocs_size; i++) {
      if (f->yklocs[i] != NULL) {
        new_locations[i] = f->yklocs[i];
      }
      else {
        new_locations[i] = NULL;
      }
    }
    free(f->yklocs);
  }
  f->yklocs = new_locations;
  f->yklocs_size = f->sizecode;
  #ifdef LYK_DEBUG
  if (is_loop_start(i)) {
    set_location(f, idx);
  }
  #endif // LYK_DEBUG
}

inline void yk_on_proto_loaded(Proto *f) {
  #ifdef LYK_DEBUG
  print_proto_info("yk_on_proto_loaded", f);
  #endif // LYK_DEBUG
  f->yklocs = calloc(f->sizecode, sizeof(YkLocation *));
  lua_assert(f->yklocs != NULL && "Expected yklocs to be defined!");
  f->yklocs_size = f->sizecode;
  for (int i = 0; i < f->sizecode; i++) {
    if (is_loop_start(f->code[i])) {
      set_location(f, i);
    }else{
      printf("[LYK] yk_on_proto_loaded. %p->yklocs[%d]=NOT A LOOP, opcode: %d\n", f, i, GET_OPCODE(i));
    }
  }
}

inline void yk_on_proto_free(Proto *f) {
  // YK locations are initialised as close as possible to the function loading,
  // However, this load can fail before we initialise `yklocs`.
  // This NULL check is a workaround for that.
  if (f->yklocs != NULL)  {
    for (int i = 0; i < f->sizecode; i++) {
      YkLocation *loc = f->yklocs[i];
      if (loc != NULL) {
        #ifdef LYK_DEBUG
        if (is_verbose()){
          printf("[LYK] yk_location_drop. %p->yklocs[%d]=%p\n", f, i, loc);
        }
        #endif // LYK_DEBUG
        yk_location_drop(*loc);
        free(loc);
      }
    }

    free(f->yklocs);
    f->yklocs = NULL;
  }
}
#endif // USE_YK
