FROM swift:5.3.1-focal as packages
RUN apt-get update && apt-get -y install rsync && rm -rf /var/lib/apt/lists/*
ADD ./Package.* ./
RUN swift package resolve
RUN mkdir -p Sources/LeafPressKit && touch Sources/LeafPressKit/empty.swift \
    && mkdir -p Sources/leaf-press && touch Sources/leaf-press/main.swift \
    && mkdir -p Tests/LeafPressKitTests && touch Tests/LeafPressKitTests/empty.swift  && touch Tests/LinuxMain.swift


FROM packages as test
RUN swift build
ADD ./Sources ./Sources
ADD ./Tests ./Tests
RUN swift test


FROM packages as release
RUN swift build -c release
ADD ./Sources ./Sources
RUN swift build -c release
