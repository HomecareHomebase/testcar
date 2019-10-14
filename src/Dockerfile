FROM hchbprod.azurecr.io/base/aspnet:latest
# FROM hchb/kerberos-base
RUN apk add --update \
    nodejs \
    npm
RUN npm install --unsafe-perm=true -g artillery
WORKDIR /app/tcfiles
WORKDIR /app
COPY trun.sh .
RUN chmod u+x trun.sh
CMD [ "./trun.sh" ]