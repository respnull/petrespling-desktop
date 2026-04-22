fn main() {
    println!("cargo:rerun-if-changed=resources.qrc");
    println!("cargo:rerun-if-changed=src/dump.rs");

    cc::Build::new()
        .cpp(true)
        .file("src/rccbridge.cpp")
        .compile("rcc");

    let status = std::process::Command::new("rcc")
        .args(&["-name", "respling", "-o", "src/rcc.cpp", "resources.qrc"])
        .status();

    match status {
        Ok(s) if s.success() => println!("rcc OK"),
        Ok(s) => eprintln!("rcc CODE {}", s),
        Err(e) => eprintln!("rcc ERROR {}", e),
    }

    cc::Build::new()
        .cpp(true)
        .file("src/wah.cpp")
        .include("src")
        .flag_if_supported("-std=c++17")
        .compile("wah");

    #[cfg(target_os = "linux")]
    println!("cargo:rustc-link-lib=X11");

    #[cfg(all(target_os = "windows", target_env = "gnu"))]
    println!("cargo:rustc-link-arg=-Wl,-subsystem,windows");

    #[cfg(all(target_os = "windows", target_env = "msvc"))]
    println!("cargo:rustc-link-arg=/SUBSYSTEM:WINDOWS");
}
