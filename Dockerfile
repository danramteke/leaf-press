FROM swift:5.3.1-focal as packages
ADD ./Package.* ./
RUN swift package resolve


FROM packages as test
ADD ./Sources ./Sources
ADD ./Tests ./Tests
RUN swift test --generate-linuxmain
RUN swift test


FROM packages as release
RUN mkdir -p Sources/LeafPressKit && touch Sources/LeafPressKit/empty.swift \
    && mkdir -p Sources/leaf-press && touch Sources/leaf-press/main.swift \
    && mkdir -p Tests/LeafPressKitTests && touch Tests/LeafPressKitTests/empty.swift  && touch Tests/LinuxMain.swift
RUN swift build -c release
ADD ./Sources ./Sources
RUN swift build -c release
