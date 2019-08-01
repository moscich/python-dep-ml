FROM python:3.7-alpine3.9 as builder
ENV PATH="/root/.local/bin:${PATH}"
RUN apk update
RUN apk add --no-cache bash
RUN apk add build-base
RUN \
 apk add --no-cache postgresql-libs && \
 apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev
RUN pip install --user numpy
RUN pip install --user pandas

RUN apk add freetype-dev
RUN pip install --user matplotlib

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.5/community" >> /etc/apk/repositories \
  && apk update \
  && apk add --update-cache --no-cache libgcc libquadmath musl \
  && apk add --update-cache --no-cache libgfortran \
  && apk add --update-cache --no-cache lapack-dev

RUN apk add gfortran

RUN pip install --upgrade pip
RUN pip install --user scipy
RUN pip install --user cython
RUN pip install --user scikit-learn
RUN pip install scikit-build
RUN apk add cmake
RUN pip install --user lightgbm

COPY requirements.txt /app/

WORKDIR /app

RUN pip install -r requirements.txt

RUN pip install boto3

RUN apk add python3-dev
RUN apk add libevent-dev
RUN apk add linux-headers

RUN pip install --user psutil

ENV PYTHONPATH=/app/
ENV PYTHONUNBUFFERED=0

