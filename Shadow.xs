#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <shadow.h>

#include "const-c.inc"

void _getspnam(const char *name) {
    dSP;
    dAXMARK;
    struct spwd *shadow;

    sp = mark;
    shadow = getspnam(name);
    if (shadow) {
        XPUSHs(sv_2mortal(newSVpvf("%s", shadow->sp_namp)));
        XPUSHs(sv_2mortal(newSVpvf("%s", shadow->sp_pwdp)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_lstchg)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_min)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_max)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_warn)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_inact)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_expire)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_flag)));
    }

    PUTBACK;
}

void _getspent(void) {
    dSP;
    dAXMARK;
    struct spwd *shadow;

    sp = mark;
    shadow = getspent();
    if (shadow) {
        XPUSHs(sv_2mortal(newSVpvf("%s", shadow->sp_namp)));
        XPUSHs(sv_2mortal(newSVpvf("%s", shadow->sp_pwdp)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_lstchg)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_min)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_max)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_warn)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_inact)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_expire)));
        XPUSHs(sv_2mortal(newSViv(shadow->sp_flag)));
    }

    PUTBACK;
}


MODULE = Linux::Shadow        PACKAGE = Linux::Shadow    

PROTOTYPES: DISABLE

INCLUDE: const-xs.inc

void
_getspnam (name)
    const char *    name
    PREINIT:
    I32* temp;
    PPCODE:
    temp = PL_markstack_ptr++;
    _getspnam(name);
    if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
      PL_markstack_ptr = temp;
      XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
    return; /* assume stack size is correct */

void
_getspent ()
    PREINIT:
    I32* temp;
    PPCODE:
    temp = PL_markstack_ptr++;
    _getspent();
    if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
      PL_markstack_ptr = temp;
      XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
    return; /* assume stack size is correct */

void
setspent ()

void
endspent ()

