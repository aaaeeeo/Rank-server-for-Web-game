# Rank-server-for-Web-game
A python web server for host web games with ranking service

## Contributors
**Baolin Fan**   
fblhalo@gmail.com   
https://github.com/finmily   
**Zuoming Li**  
zuomingli@uchicago.edu  
https://github.com/aaaeeeo/  

## Usage
Config file: /gamerank/config.py
Setup file: /setup.py  

Server: /gamerank/server.py
```
python3 gamerank/server.py
```

## Project Structure    
```
├── README.md
├── database
│   ├── gamerank_2016-01-10.sql
│   └── gamerank_2016-01-10_withtestdata.sql
├── gamerank
│   ├── __init__.py
│   ├── config.py
│   ├── modules
│   │   ├── __init__.py
│   │   ├── controller.py
│   │   ├── dbhandler.py
│   │   ├── httphandler.py
│   │   ├── model.py
│   │   └── pathhelper.py
│   ├── pages
│   └── server.py
├── setup.py
└── tests
    ├── __init__.py
    └── gamerank_tests.py
```


