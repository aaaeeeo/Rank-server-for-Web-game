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
    'install_requires': ['pymongo'],
    'packages': ['gamerank'],
    'scripts': [],
    'name': 'gamerank'
}

setup(**config)