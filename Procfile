web: bundle exec puma -t ${PUMA_MIN_THREADS:-2}:${PUMA_MAX_THREADS:-4} -w ${PUMA_WORKERS:-2} -p $PORT -e ${RACK_ENV:-development}
