#Setup.py
#create in 12/06/2023 by Deborah Volpe
#this file compile the cpp cores for their integration in python code

from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext
from Cython.Build import cythonize
import numpy

setup(
    name='SimulatedBifurcationMachineTMFix',
    ext_modules=cythonize([Extension(name='GeneralSimulatedBifurcationMachineTMF',
                                     sources=['SimulatedBifurcation_wrapperTMFixed.pyx', 'SimulatedBifurcationTMFixed.cpp'],
                                     depends=["SimulatedBifurcationTMFixed.h"],
                                     include_dirs=['./',
                                     numpy.get_include()],
                                     language='c++',
                                     extra_compile_args=['/std:c++14'],
                                     define_macros=[('NPY_NO_DEPRECATED_API', 'NPY_1_7_API_VERSION')])]),
    cmdclass={'build_ext': build_ext},
)
