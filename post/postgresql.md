## posgresql 

### 1.更新database 编码
update pg_database set encoding = pg_char_to_encoding('UTF8') where datname = 'thedb'

### 2.远程连接postgresql

http://www.2cto.com/database/201310/250297.html