/* File : pyKDL.i */
%module pyKDL
%include "typemaps.i"

%{
/* Note : always include headers following the inheritance order */

#include <kdl/utilities/kdl-config.h>
#include <kdl/utilities/utility.h>
#include <kdl/frames.hpp>
%}

/* Note : always include headers following the inheritance order */

#ifdef KDL_INLINE
    #ifdef _MSC_VER
        // Microsoft Visual C
        #define IMETHOD __forceinline
    #else
        // Some other compiler, e.g. gcc
        #define IMETHOD inline
    #endif
#else
    #define IMETHOD
#endif


namespace KDL
{
%apply KDL::Vector& OUTPUT { KDL::Vector& axis };
%apply double& OUTPUT { double& x,double& y,double& z, double& w };
%apply double& OUTPUT { double& roll,double& pitch,double& yaw };
}

%ignore KDL::Frame2::Integrate(const Twist& t_this,double frequency);
%ignore KDL::Frame2::Make4x4(double* d);

%rename(assign)  KDL::Vector::operator=( const Vector& arg);
%extend KDL::Vector {
    Vector __add__(const Vector& rhs) {
        return *($self) + rhs;
    }

    Vector __sub__(const Vector& rhs) {
        return *($self) - rhs;
    }

    Vector __mul__(const Vector& rhs) {
        return *($self) * rhs;
    }
}


%rename(assign)  KDL::Rotation::operator=(const Rotation& arg);
%extend KDL::Rotation {

    Vector __mul__(const Vector& v) const {
        return *($self) * v;
    }

    Rotation __mul__(const Rotation& rhs) {
        return *($self) * rhs;
    }
}

%rename(assign)  KDL::Frame::operator=(const Frame& arg);
%extend KDL::Frame {
    Vector __mul__(const Vector& arg) const {
        return *($self) * arg;
    }

    Frame __mul__(const Frame& rhs) {
        return *($self) * rhs;
    }

    Vector p() {
        return $self->p;
    }

    Rotation M() {
        return $self->M;
    }

}

%include <kdl/frames.hpp>

%feature("autodoc","1");
