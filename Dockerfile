FROM python:3.9-alpine AS deps
ADD requirements.txt requirements.txt
RUN apk --update add gcc build-base libffi-dev openssl-dev && \
    pip install -r requirements.txt

FROM python:3.9-alpine AS install
ADD . .
COPY --from=deps /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.8/site-packages
RUN python setup.py install

FROM python:3.9-alpine
COPY --from=install /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.8/site-packages
ENTRYPOINT ["/usr/local/bin/python3.9", "-m", "openshift_csr_approver"]

LABEL maintainer="Michael Hopstock <michael.hopstock@gmail.com>"
LABEL version="0.2.0"
