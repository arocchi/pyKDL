/* File : pyKDL.i */
%module pyKDL

%{
#define SWIG_FILE_WITH_INIT
%}

%include "typemaps.i"
%include "std_string.i"

%include "numpy.i"

%init %{
    import_array();
%}

%{
/* Note : always include headers following the inheritance order */

#include <kdl/utilities/kdl-config.h>
#include <kdl/utilities/utility.h>
#include <kdl/frames.hpp>
#include <kdl/frames_io.hpp>
#include <sstream>
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

%ignore KDL::Vector::data;
%rename(assign)  KDL::Vector::operator=( const Vector& arg);
%extend KDL::Vector {
    double data[3];

    Vector __add__(const Vector& rhs) {
        return *($self) + rhs;
    }

    Vector __sub__(const Vector& rhs) {
        return *($self) - rhs;
    }

    Vector __mul__(const Vector& rhs) {
        return *($self) * rhs;
    }

    std::string __repr__() {
        std::stringstream ss;
        ss << *($self);
        return ss.str();
    }

    const PyObject* ndarray() {
        npy_intp dims[] = {3};
        return PyArray_SimpleNewFromData(1, dims, NPY_DOUBLE, (void*)$self->data);
    }
}

%typemap(in) (int matrix_i_row, int matrix_i_col) {
    if (!PyTuple_Check($input)) {
        PyErr_SetString(PyExc_ValueError, "Error: expecting a tuple (m[1,2] is equivalent to m[(1,2)])");
        return NULL;
    }

    if (PyTuple_Size($input) != 2 ) {
        PyErr_SetString(PyExc_ValueError, "Matrix elements are accessed by using two integers m[i_row,i_col]");
        return NULL;
    }

    $1 = (int)PyInt_AsLong(PyTuple_GetItem($input,0));   /* int i */
    $2 = (int)PyInt_AsLong(PyTuple_GetItem($input,1));   /* int j */
};
%ignore KDL::Rotation::data;
%rename(_set) KDL::Rotation::operator()(int i, int j);
%rename(_get) KDL::Rotation::operator()(int i, int j) const;
%rename(assign)  KDL::Rotation::operator=(const Rotation& arg);
%extend KDL::Rotation {
    Vector __mul__(const Vector& v) const {
        return *($self) * v;
    }

    Rotation __mul__(const Rotation& rhs) {
        return *($self) * rhs;
    }

    std::string __repr__() {
        std::stringstream ss;
        ss << *($self);
        return ss.str();
    }

    const PyObject* ndarray() {
        npy_intp dims[] = {3, 3};
        return PyArray_SimpleNewFromData(2, dims, NPY_DOUBLE, (void*)$self->data);
    }

    void __setitem__(int matrix_i_row, int matrix_i_col, double value) {
        $self->operator ()(matrix_i_row,matrix_i_col) = value;
    }

    double __getitem__(int matrix_i_row, int matrix_i_col) {
        return $self->operator ()(matrix_i_row,matrix_i_col);
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

    Vector& p() {
        return $self->p;
    }

    Rotation& M() {
        return $self->M;
    }

    std::string __repr__() {
        std::stringstream ss;
        ss << *($self);
        return ss.str();
    }
}

%include <kdl/frames.hpp>

%feature("autodoc","1");
