FROM redislabs/rejson:latest as rejson
FROM redislabs/redisearch:latest as redisearch
FROM redislabs/redisgears:latest


ENV LD_LIBRARY_PATH /usr/lib/redis/modules
ENV REDISGRAPH_DEPS libgomp1
RUN mkdir -p /usr/local/etc/redis
COPY redis.conf /usr/local/etc/redis/redis.conf
WORKDIR /data
RUN set -ex; \
    apt-get update; \
    apt-get install vim -y; \
    apt-get install -y --no-install-recommends ${REDISGRAPH_DEPS};
COPY --from=rejson ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
COPY --from=redisearch ${LD_LIBRARY_PATH}/*.so ${LD_LIBRARY_PATH}/
# ENV PYTHONPATH /usr/lib/redis/modules/deps/cpython/Lib
ENTRYPOINT ["redis-server"]
CMD ["/usr/local/etc/redis/redis.conf"]
