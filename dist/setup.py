"""A setuptools based setup module.

See:
https://packaging.python.org/en/latest/distributing.html
https://github.com/pypa/sampleproject
"""

# Always prefer setuptools over distutils
from setuptools import setup, find_packages, Distribution
# To use a consistent encoding
from codecs import open
from os import path

class BinaryDistribution(Distribution):
    def is_pure(self):
        return False


here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='pyKDL',
    version='1.0.2',
    description=' SWIG Python bindings to KDL, making use of numpy arrays.',
    long_description=long_description,
    url='https://github.com/arocchi/pyKDL',
    author='Alessio Rocchi',
    author_email='rocchi.alessio@gmail.com',
    license='MIT',

    install_requires=['numpy==1.2.1'],
    #py_modules=["pyKDL"],
    #include_package_data=True,
    distclass=BinaryDistribution,

    packages = ['pyKDL'],
    package_dir={'pyKDL': '.'},
    package_data={
        'pyKDL': ['_pyKDL.pyd'],
    }
)
