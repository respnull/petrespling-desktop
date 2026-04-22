#![windows_subsystem = "windows"]

use qmetaobject::*;
use image::GenericImageView;

#[link(name = "rcc", kind = "static")]
unsafe extern "C" { fn qInitResources_respling_c(); }

#[link(name = "wah")]
unsafe extern "C" { pub fn gwa() -> WAH; }

#[repr(C)]
pub struct WAH { pub x: i32, pub y: i32, pub width: i32, pub height: i32, }

const ASSETS: &[(u8, &[u8])] = &[
    (0, include_bytes!("../respling.png")),
    (1, include_bytes!("../petresp.png")),
    (2, include_bytes!("../eatresp.png")),
    (3, include_bytes!("../respsad.png")),
    (4, include_bytes!("../respsleep.png")),
    (5, include_bytes!("../respsleepz.png")),
    (6, include_bytes!("../droolresp.png")),

    (101, include_bytes!("../wizard.png")),
    (102, include_bytes!("../construction.png")),
    (103, include_bytes!("../siren.png")),
    (104, include_bytes!("../king.png")),
    (105, include_bytes!("../halo.png")),
    (106, include_bytes!("../long.png")),
    (107, include_bytes!("../birthday.png")),
    (108, include_bytes!("../traffic.png")),
];

fn main() {
    unsafe { qInitResources_respling_c(); }

    let rect: WAH = unsafe { gwa() };
    let wayland = std::env::var("WAYLAND_DISPLAY").is_ok();

    let mut engine = QmlEngine::new();

    if wayland {
        println!("[WARNING] Certain features have been disabled due to your display protocol's (Wayland) limitations.");
    }

    #[cfg(target_os = "linux")] {
        let mut workarea: QVariantMap = Default::default();
        workarea.insert(QString::from("x"), rect.x.into());
        workarea.insert(QString::from("y"), rect.y.into());
        workarea.insert(QString::from("width"), rect.width.into());
        workarea.insert(QString::from("height"), rect.height.into());
        engine.set_property(QString::from("workarea"), workarea.into());
    }

    #[cfg(not(target_os = "linux"))]
    engine.set_property("workarea".into(), QVariant::default());

    engine.set_property("wayland".into(), wayland.into());

    for (id, ctx) in ASSETS {
        let pixels = decode_image(ctx, *id);

        engine.set_property(format!("pixelData_{}", id).into(), pixels.into());
    }

    engine.load_url(qmetaobject::QString::from("qrc:/src/resp.qml").into());
    engine.exec();
}

fn decode_image(bytes: &[u8], id: u8) -> QVariantList {
    let img = image::load_from_memory(bytes).expect("decode");

    let mut pixels = QVariantList::default();
    let w = 16;
    let h = if id == 102 || id == 104 || id == 105 { 8 } else { 16 };

    for y in 0..h {
        for x in 0..w {
            let p = img.get_pixel(x, y);
            let color = format!("#{:02x}{:02x}{:02x}{:02x}", p[3], p[0], p[1], p[2]);
            pixels.push(QString::from(color).into());
        }
    }

    pixels
}
