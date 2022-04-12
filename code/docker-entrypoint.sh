#!/bin/bash

ownership() {
    # Fixes ownership of output files
    # source: https://github.com/BD2KGenomics/cgl-docker-lib/blob/master/mutect/runtime/wrapper.sh#L5
    user_id=$(stat -c '%u:%g' /code)
    chown -R ${user_id} /code
}


echo "Waiting for postgress"
chmod +x wait-for-it.sh
./wait-for-it.sh -t 80 $POSTGRES_SERVICE:$POSTGRES_PORT || exit 1
cd .code/

echo ''
echo '--------------------------'
echo 'Database migration'
echo '--------------------------'
echo ''

python manage.py makemigrations || exit 1
python manage.py migrate || exit 1

echo ''
echo '--------------------------'
echo 'Collect static'
echo '--------------------------'
echo ''
python manage.py collectstatic --noinput


echo ''
echo '--------------------------'
echo 'Fixing ownership of files'
echo '--------------------------'
echo ''
ownership

echo ''
echo '--------------------------'
echo 'Run command'
echo $@
echo '--------------------------'
echo ''
$@ || exit 1