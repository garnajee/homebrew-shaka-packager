class ShakaPackager < Formula
  desc "SDK for media packaging of DASH/HLS content (includes packager, pssh-box.py, and mpd_generator)"
  homepage "https://github.com/shaka-project/shaka-packager"
  url "https://github.com/shaka-project/shaka-packager.git",
      tag:      "v3.4.0",
      revision: "ef1d8995c6c1e6f4df5b9c1d8f7cbb3a8d383bbe",
      shallow:  true
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "git" => :build
  depends_on "python@3.11" => :build

  def install
    system "git", "submodule", "update", "--init", "--recursive"

    mkdir "build" do
      args = std_cmake_args + [
        "-G", "Ninja",
        "-DCMAKE_BUILD_TYPE=Release",
        "-DBUILD_SHARED_LIBS=OFF"
      ]
      system "cmake", "..", *args
      system "cmake", "--build", ".", "--parallel"
      system "cmake", "--install", ".", "--strip"
    end
  end

  test do
    assert_match "packager", shell_output("#{bin}/packager -h")
  end
end

