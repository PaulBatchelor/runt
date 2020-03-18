/* testing out nextfree functionality */
#include <stdio.h>
#include "runt.h"

int main(int argc, char *argv[])
{
   runt_vm vm;
   int nf;
   runt_stacklet *s;
   runt_vm_alloc(&vm, 512, RUNT_MEGABYTE * 2);

   nf = runt_register_nextfree(&vm, 0);
   runt_print(&vm, "nf is %d\n", nf);

   /* store the VM in register NF */
   runt_register_get(&vm, nf, &s);
   s->p = runt_mk_cptr(&vm, &vm);

   /* find the next free, starting at 0 */
   nf = runt_register_nextfree(&vm, 0);
   runt_print(&vm, "nf is %d\n", nf);

   /* store the pointer location of nf now */
   runt_register_get(&vm, nf, &s);
   s->p = runt_mk_cptr(&vm, &nf);

   /* find another free register, starting at nf + 1 */
   nf = runt_register_nextfree(&vm, nf);
   runt_print(&vm, "nf is %d\n", nf);

   runt_vm_free(&vm);
}
