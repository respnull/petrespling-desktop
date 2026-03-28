use qmetaobject::*;
use image::GenericImageView;

const ASSETS: &[(u8, &[u8])] = &[
    (0, include_bytes!("../respling.png")),
    (1, include_bytes!("../petresp.png")),
    (2, include_bytes!("../eatresp.png")),
    (3, include_bytes!("../respsad.png")),
    (4, include_bytes!("../respsleep.png")),
    (5, include_bytes!("../respsleepz.png")),
];

fn main() {
    let mut optheight: i32 = 200;

    #[cfg(target_os = "windows")] {
        optheight = 310;
    }

    let mut engine = QmlEngine::new();

    engine.set_property("optheight".into(), optheight.into());

    for (id, ctx) in ASSETS {
        let pixels = decode_image(ctx);

        engine.set_property(format!("pixelData_{}", id).into(), pixels.into());
    }

    engine.load_file("src/resp.qml".into());
    engine.exec();
}


fn decode_image(bytes: &[u8]) -> QVariantList {
    let img = image::load_from_memory(bytes).expect("decode");

    let mut pixels = QVariantList::default();

    for y in 0..16 {
        for x in 0..16 {
            let p = img.get_pixel(x, y);
            let color = format!("#{:02x}{:02x}{:02x}{:02x}", p[3], p[0], p[1], p[2]);
            pixels.push(QString::from(color).into());
        }
    }

    pixels
}
