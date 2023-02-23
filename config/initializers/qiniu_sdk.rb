require 'qiniu'
Qiniu.establish_connection! access_key: CONFIG.qiniu_access_key,
                            secret_key: CONFIG.qiniu_secret_key