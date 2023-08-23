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

int is_verbose()
{
  if (LYK_VERBOSE == -1)
  {
    LYK_VERBOSE = getenv("LYK_VERBOSE") != NULL;
  }
  return LYK_VERBOSE;
}

// int is_valid_yk_location(YkLocation loc) {
//   return loc.state != 0;
// }

void print_proto_info(char *msg, Proto *f)
{
  if (!is_verbose()){
    return;
  }
  char *source = getstr(f->source);
  char *vars = NULL;
  if (f->locvars != NULL && f->locvars->varname != NULL)
  {
    vars = getstr(f->locvars->varname);
  }
  printf("[DEBUG] %s. \t f:\t%p \t source: %s: \t vars: %s \n", msg, f, source, vars);
  // if (f->yklocs != NULL){
  //   for (int i = 0; i < f->sizecode; i++){
  //     printf("[DEBUG]");
  //     if (is_valid_yk_location(f->yklocs[i])){
  //       printf("%p->yklocs[%d]=%p,", f, i, f->yklocs[i]);
  //     }else{
  //       printf("%p->yklocs[%d]=NULL,", f, i);
  //     }
  //     printf("\n");
  //   }
  // }
}

void yk_new_proto(Proto *f)
{
  if (is_verbose())
  {
    printf("yk_new_proto %p\n", f);
  }
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
 *de
 */
int is_loop_start(Instruction i)
{
  return (GET_OPCODE(i) == OP_FORLOOP || GET_OPCODE(i) == OP_TFORLOOP);
}

inline YkLocation *yk_lookup_ykloc(CallInfo *ci, Instruction *pc)
{
  YkLocation *ykloc = NULL;
  lua_assert(isLua(ci));
  Proto *p = ci_func(ci)->p;
  lua_assert(p->code <= pc && pc <= p->code + p->sizecode);
  if (is_loop_start(*pc))
  {
    ykloc = &p->yklocs[pc - p->code];
  }
  return ykloc;
}

inline void yk_set_location(Proto *f, Instruction i, int idx, int pc)
{
  // if (f->yklocs == NULL)
  // {
  //   print_proto_info("yk_set_location, calloc", f);
  //   f->yklocs = calloc(f->sizecode, sizeof(YkLocation));
  // }
  // else
  // {
    // print_proto_info("yk_set_location, reallocarray", f);
    // YKOPT: Reallocating for every instruction is inefficient.
  f->yklocs = reallocarray(f->yklocs, pc, sizeof(YkLocation));
  // }

  lua_assert(f->yklocs != NULL && "Expected yklocs to be defined!");
  if (is_loop_start(i))
  {
    print_proto_info("yk_location_new", f);
    YkLocation loc = yk_location_new();
    f->yklocs[idx] = loc;
    printf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@ yk_location_new. loc: %p, state: %lu\n", loc, loc.state);
    yk_location_drop(loc);
    printf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@ yk_location_drop. loc: %p, state: %lu\n, idx: %d", loc, loc.state, idx);
  }
}

inline void yk_init_proto(Proto *f)
{
  f->yklocs = calloc(f->sizecode, sizeof(YkLocation));
  lua_assert(f->yklocs != NULL && "Expected yklocs to be defined!");
  print_proto_info("yk_init_proto", f);
  for (int i = 0; i < f->sizecode; i++)
  {
    if (is_loop_start(i))
    {
      print_proto_info("yk_location_new", f);
      f->yklocs[i] = yk_location_new();
    }
  }
}

inline void yk_free_proto(Proto *f)
{
  print_proto_info("yk_free_proto", f);
  // YK locations are initialised as close as possible to the function loading,
  // However, this load can fail before we initialise `yklocs`.
  // This NULL check is a workaround for that.
  if (f->yklocs != NULL)
  {
    for (int i = 0; i < f->sizecode; i++)
    {
      if (is_loop_start(i))
      {
        print_proto_info("yk_location_drop", f);
        YkLocation loc = f->yklocs[i];
        // YkLocations are set with calloc which that 0 bytes are written to the memory.
        // But YkLocations themselves can be uninitialized.
        // This check makes sure that we only free locations that are initialised via `yk_location_new` function.
        printf("[DEBUG] Detected loop location. %p->yklocs[%d]=%p\n", f, i, loc);
        // if (is_valid_yk_location(f->yklocs[i])){
          printf("[DEBUG] Dropped. %p->yklocs[%d]=%p\n", f, i, loc);
          yk_location_drop(loc);
        // }
      }
    }
    free(f->yklocs);
    f->yklocs = NULL;
  }
}
#endif // USE_YK
