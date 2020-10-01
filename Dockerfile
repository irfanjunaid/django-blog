FROM python:3.6-alpine

# Python dependencies
COPY requirements.txt .

RUN apk update && apk add libpq\
    && apk add --no-cache --virtual .build-deps postgresql-dev gcc musl-dev\
    && pip install --no-cache-dir -r requirements.txt\
    && rm -f requirements.txt\
    && apk del .build-deps\
    && rm -rf /var/cache/apk/*

EXPOSE 8000

ENV WORKING_DIR /app

WORKDIR $WORKING_DIR

# Project files
COPY manage.py $WORKING_DIR/manage.py
COPY blog $WORKING_DIR/blog
COPY mysite $WORKING_DIR/mysite

# Run migrations, and load the database with fixtures
# Migrations is run on k8s seperately. un-comment if needed
# RUN python manage.py migrate && python manage.py loaddata users posts comments

ENTRYPOINT ["python", "manage.py"]
CMD ["runserver", "0.0.0.0:8000"]
