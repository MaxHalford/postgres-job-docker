# JOB + PostgreSQL

The [Join Order Benchmark (JOB)](https://github.com/gregrahn/join-order-benchmark) is a set of queries designed to evaluate the performance of database systems. It is meant to be executed against [data from IMDb](https://www.imdb.com/interfaces/), I have been using the benchmark during my PhD to evaluate query optimisation methods. This repository contains a simple setup for building a PostgreSQL database instance with all the necessary data inside a [Docker container](https://www.wikiwand.com/en/Docker_(software)). You will then be able to connect to the database via `localhost`. A [pgweb](https://github.com/sosedoff/pgweb) instance is also made available for querying the data.

You first need to install the community edition of Docker; instructions can be found [here](https://docs.docker.com/install/).

The `docker-compose.yml` file contains the details of the Docker instance that will be built. You can build it using the following command.

```sh
docker-compose build
```

You may then start the services. This will launch PostgreSQL, as well as the pgweb interface.

```sh
docker-compose up -d
```

You now have to provision the database with the IMDB data. This takes a few hours but thankfully you only have to do it once.

```sh
docker-compose run --rm job bash setup.sh
```

You can now access the [pgweb](https://github.com/sosedoff/pgweb) interface by navigating to [localhost:8081](localhost:8081). You can stop the services once you are done.

```sh
docker-compose down
```

The connection details for the PostgreSQL instance are as follows:

- Host: `localhost`
- Port: `5432`
- Database name: `job`
- User name: `postgres`
- Password: `postgres`

Here is a connection example using [SQLAlchemy](http://docs.sqlalchemy.org/en/latest/core/engines.html) under Python 3:

```python
import sqlalchemy
from sqlalchemy import orm

uri = 'postgresql://postgres:postgres@localhost:5432/job'
engine = sqlalchemy.create_engine(uri)
session = orm.sessionmaker(bind=engine)()
session.execute('SELECT COUNT(*) FROM cast_info')
```

You can now run any of the JOB queries available from [here](https://github.com/gregrahn/join-order-benchmark). Feel free to get in touch with me at [maxhalford25@gmail.com](mailto:maxhalford25@gmail.com) if you have any questions; or even better [open an issue](https://github.com/MaxHalford/pg-job-docker/issues/new).
