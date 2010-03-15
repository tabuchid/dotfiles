#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
pastemacs
---------

Provides lodgeit integration for emacs through pymacs.

To use it, add the following line to your ``~/.emacs``::

    (pymacs-load "pastemacs" "paste-")

To enable the menu, add the following line after the above::

    (paste-menu)
"""


from setuptools import setup


setup(
    name='pastemacs',
    version='0.1.1',
    url='http://www.lunaryorn.de/code/pastemacs.html',
    author='Sebastian Wiesner',
    author_email='basti.wiesner@gmx.net',
    description='Lodgeit integration for emacs',
    long_description=__doc__,
    license='GPL',
    classifiers=[
        'Development Status :: 4 - Beta',
        'License :: OSI Approved :: GNU General Public License (GPL)',
        'Environment :: Plugins',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Intended Audience :: Developers',
        'Topic :: Text Editors :: Emacs'
        ],
    # to get our sdist ready without any silly manifest
    setup_requires=['setuptools-hg'],
    py_modules=['pastemacs'],
    install_requires=['lodgeitlib'],
    )
