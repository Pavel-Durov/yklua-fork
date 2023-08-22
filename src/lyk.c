#ifdef USE_YK

#include "lyk.h"
#include "lobject.h"
#include "lopcodes.h"
#include "ldebug.h"
#include <stdlib.h>
#include <yk.h>
 #include "stdio.h"

#define _DEFAULT_SOURCE /* for reallocarray() */

static int LYK_VERBOSE = -1;

int is_verbose() {
  if (LYK_VERBOSE == -1){
    LYK_VERBOSE = getenv("LYK_VERBOSE") != NULL;
  }
  return LYK_VERBOSE;
}

void log_debug(char *message) {
  LYK_VERBOSE = is_verbose();
  if (is_verbose()){
    printf("[DEBUG] %s", message);
  }
}

void print_proto_info(char *msg, Proto *f){
  char *source = getstr(f->source);
   
  char *vars = NULL;

  if (f->locvars != NULL && f->locvars->varname != NULL){
    vars = getstr(f->locvars->varname);
  }
  printf("[DEBUG] %s. \t f:\t%p \t source: %s: \t vars: %s \n", msg, f, source, vars);
}


void yk_new_proto(Proto *f) {
  // print_proto_info("yk_new_proto", f);
  f->yklocs = NULL;
}
/*
 *  Function prototypes in Lua are loaded through two methods:
 *    1.  They are loaded from text source via the `luaY_parser`.
 *    2.  They can also be loaded from binary representation using `luaU_undump`, where
 *        prototypes are previously dumped and saved.
 * 
 *  Yk tracing locations are allocated using both of these methods 
 *  using `yk_set_location` and `yk_set_locations` respectively.
*/

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

inline YkLocation *yk_lookup_ykloc(CallInfo *ci, Instruction *pc){
  YkLocation *ykloc = NULL;
  lua_assert(isLua(ci));
  Proto *p = ci_func(ci)->p;
  lua_assert(p->code <= pc && pc <= p->code + p->sizecode);
  if (is_loop_start(*pc)) {
    ykloc = &p->yklocs[pc - p->code];
  }
  return ykloc;
}

inline void yk_set_location(Proto *f, Instruction i, int idx, int pc) {
  if (f->yklocs == NULL){
    print_proto_info("yk_set_location", f);
    f->yklocs = calloc(f->sizecode, sizeof(YkLocation));
  } else {
    // YKOPT: Reallocating for every instruction is inefficient.
    f->yklocs = reallocarray(f->yklocs, pc, sizeof(YkLocation));
  }
  
  lua_assert(f->yklocs != NULL && "Expected yklocs to be defined!");
 

  // for (int i = 0; i < f->sizecode; i++){
  //   printf("yklocs[%d]=%p,", i, f->yklocs[i]); 
  // }
  // printf("\n");
  if (is_loop_start(i))
  {
    print_proto_info("yk_location_new", f);
    f->yklocs[idx] = yk_location_new();
  }


}

inline void yk_init_proto(Proto *f) {
  f->yklocs = calloc(f->sizecode, sizeof(YkLocation));
  lua_assert(f->yklocs != NULL && "Expected yklocs to be defined!");
  print_proto_info("yk_init_proto", f);
  for (int i = 0; i < f->sizecode; i++){
     if (is_loop_start(i)){
      print_proto_info("yk_location_new", f);
      f->yklocs[i] = yk_location_new();
    }else{
      // f->yklocs[i] = NULL;
    }
  }

  for (int i = 0; i < f->sizecode; i++){
    printf("yklocs[%d]=%p,", i, f->yklocs[i]); 
  }
  printf("\n");
}


inline void yk_free_proto(Proto *f) {
  print_proto_info("yk_free_proto", f);
  // YK locations are initialised as close as possible to the function loading, 
  // However, this load can fail before we initialise `yklocs`.
  // This NULL check is a workaround for that.
  if (f->yklocs != NULL) {
    for (int i = 0; i < f->sizecode; i++) {
      if (is_loop_start(i) && &f->yklocs[i] != NULL) {
        print_proto_info("yk_location_drop", f);
        YkLocation loc = f->yklocs[i];
        printf("[DEBUG] Detected loop location. f->yklocs[%d]=%p\n", i, loc);
        
        // if (&loc == NULL){
        //   printf("@@@@@@@@@@@@@@ YEY\n");
        // }else{
        //   printf("@@@@@@@@@@@@@@ NEY\n");
        // }
        // printf("@@@@@@@@@@@@@@ NADA\n");
        // TODO: continue here
        yk_location_drop(f->yklocs[i]);
      }
    }
    free(f->yklocs);
    f->yklocs = NULL;
  }
}
#endif // USE_YK
