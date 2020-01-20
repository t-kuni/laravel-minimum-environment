# Laravel Minimum Environment

PHP, composer, nginx, cron, MySQLを含む最小構成

```
git clone ssh://git@github.com/t-kuni/laravel-minimum-environment [name]
cd [name]
rm -rf .git
```

Make .env

```
cp .env.example .env
```

Make server certification.

```
docker run --rm -v $PWD/certs:/out -e HOST=example.com -e IP=192.168.99.100 tkuni83/self-sign-cert
```

Run

```
docker-compose up -d
```

Boot shell

```
docker-compose exec app sh
```