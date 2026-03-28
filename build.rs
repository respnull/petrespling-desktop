fn main() {
    #[cfg(all(target_os = "windows", target_env = "gnu"))]
    println!("cargo:rustc-link-arg=-Wl,-subsystem,windows");

    #[cfg(all(target_os = "windows", target_env = "msvc"))]
    println!("cargo:rustc-link-arg=/SUBSYSTEM:WINDOWS");
}
