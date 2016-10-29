FROM debian:8

RUN mkdir build
WORKDIR build

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git g++ cmake libboost-all-dev libzmq-dev libosmpbf-dev libboost-all-dev libpqxx3-dev libgoogle-perftools-dev  libprotobuf-dev libproj-dev protobuf-compiler libgeos-c1 liblog4cplus-dev
 
RUN git clone --depth=1 --single-branch --branch=dev https://github.com/CanalTP/navitia.git

WORKDIR navitia

RUN sed -i 's,git\@github.com:\([^/]*\)/\(.*\).git,https://github.com/\1/\2,' .gitmodules
RUN git submodule update --init

RUN cmake -DCMAKE_BUILD_TYPE=Release source && make -j$(nproc)

RUN apt-get install -y apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y docker-engine

#CMD git pull && git submodule update --init && make -j$(nproc) && 

ADD Dockerfile-jormungandr source/Dockerfile-jormungandr
ADD Dockerfile-kraken kraken/Dockerfile-kraken
ADD Dockerfile-tyr Dockerfile-tyr

RUN echo "**/*.a" > .dockerignore
RUN echo "**/CMakeFiles/*" >> .dockerignore
RUN echo "**/*.o" >> .dockerignore
RUN echo ".git" >> .dockerignore
RUN echo "**/CMakeFiles" >> .dockerignore
RUN echo "**/*.cpp" >> .dockerignore
RUN echo "**/*.h" >> .dockerignore
RUN echo "**/tests" >> .dockerignore
RUN echo "**/test" >> .dockerignore

ADD build.sh build.sh
CMD ./build.sh
#CMD ls -lh && cat .dockerignore
