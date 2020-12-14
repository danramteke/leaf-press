FROM swift:5.3.1-focal as packages
RUN apt-get update && apt-get -y install rsync curl \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update && apt-get -y install yarn nodejs \
    && rm -rf /var/lib/apt/lists/*
ADD ./Package.* ./
RUN swift package resolve
RUN mkdir -p Sources/LeafPressKit && touch Sources/LeafPressKit/empty.swift \
    && mkdir -p Sources/leaf-press && touch Sources/leaf-press/main.swift \
    && mkdir -p Tests/LeafPressKitUnitTests && touch Tests/LeafPressKitUnitTests/empty.swift \
    && mkdir -p Tests/LeafPressKitIntegrationTests && touch Tests/LeafPressKitIntegrationTests/empty.swift \
    && touch Tests/LinuxMain.swift


FROM packages as test
RUN swift build
ADD ./Sources ./Sources
ADD ./Tests ./Tests
RUN swift test


FROM packages as release
RUN swift build -c release
ADD ./Sources ./Sources
RUN swift build -c release
