# encoding = utf-8
"""
Created on 2016-1-5
@author: LZM
"""

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

config = {
    'description': 'Rank server for Web game',
    'author': 'Zuoming Li & Baolin Fan',
    'url': 'https://github.com/aaaeeeo/Rank-server-for-Web-game',
    'download_url': 'https://github.com/aaaeeeo/Rank-server-for-Web-game/archive/master.zip',
    'author_email': 'zuomingli@uchicago.edu',
    'version': '0.1',
    'install_requires': ['mysqlclient'],
    'packages': ['gamerank'],
    'scripts': [],
    'name': 'gamerank',
}

setup(**config)


