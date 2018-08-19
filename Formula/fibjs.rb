class Fibjs < Formula
  desc "JavaScript on Fiber"
  homepage "http://fibjs.org/"
  url "https://github.com/fibjs/fibjs/releases/download/v0.26.1/fullsrc.zip"
  sha256 "36bf6add810959c9474a0f247473fe3b2a34f49cb7a3bcc4a5ac5d7fced17068"
  head "https://github.com/fibjs/fibjs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79e11d5e3531760340709d7cbcedd8763c29d9c6569d01f15de112b6a28ac0f4" => :high_sierra
    sha256 "304a2b7222c7ed5c4ebefee09b5fd713d18a46cbf0e210111ab1966ffaa4802d" => :sierra
  end

  depends_on :macos => :sierra # fibjs requires >= Xcode 8.3 (or equivalent CLT)
  depends_on "cmake" => :build

  def install
    # the build script breaks when CI is set by Homebrew
    begin
      env_ci = ENV.delete "CI"
      system "./build", "release", "-j#{ENV.make_jobs}"
    ensure
      ENV["CI"] = env_ci
    end

    bin.install "bin/Darwin_amd64_release/fibjs"
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/fibjs #{path}").strip
    assert_equal "hello", output
  end
end
