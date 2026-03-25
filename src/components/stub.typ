#import "/src/component.typ": component, interface
#import "/src/dependencies.typ": cetz
#import "/src/mini.typ": ac-sign
#import "/src/utils.typ": get-style, opposite-anchor
#import "/src/components/wire.typ": wire
#import cetz.draw: anchor, circle, content, line, mark, polygon, rect, set-style

#let stub(node, dir: "north", invert: false, ..params) = {
    assert(params.pos().len() == 0, message: "stub must have exactly one node")
    assert(invert in (true, false, "wedge"), message: "invert should be boolean or 'wedge'")

    let args = params.named()
    if "label" in args and args.label != none {
        if type(args.label) == dictionary {
            args = args + (label: args.label + (anchor: dir))
        } else {
            args = args + (label: (content: args.label, anchor: dir, align: opposite-anchor(dir)))
        }
    }

    // Drawing function
    let draw(ctx, position, style) = {
        let r = style.at("invert-radius", default: 0.06)

        let diff = {
            if dir == "north" { (0.001, style.length) } else if dir == "south" { (0.001, -style.length) } else if dir == "east" { (style.length, 0.001) } else {
                (-style.length, 0.001)
            }
        }

        interface((0, 0), diff, io: false)

        let start-pos = {
            if dir == "north" {
                (0, if invert == true { 2 * r } else if invert == "wedge" { style.invert-width } else { 0 })
            } else if dir == "south" {
                (0, if invert == true { -2 * r } else if invert == "wedge" { -style.invert-width } else { 0 })
            } else if dir == "east" {
                (if invert == true { 2 * r } else if invert == "wedge" { style.invert-width } else { 0 }, 0)
            } else {
                (if invert == true { -2 * r } else if invert == "wedge" { -style.invert-width } else { 0 }, 0)
            }
        }

        wire(start-pos, diff)

        if invert == "wedge" {
            if dir == "east" {
                line((0, style.invert-height), (style.invert-width, 0), stroke: 0.5pt)
                line((0, 0), (style.invert-width, 0), stroke: 0.5pt)
            } else if dir == "west" {
                line((0, style.invert-height), (-style.invert-width, 0), stroke: 0.5pt)
                line((0, 0), (-style.invert-width, 0), stroke: 0.5pt)
            } else if dir == "north" {
                line((-style.invert-height, 0), (0, style.invert-width), stroke: 0.5pt)
                line((0, 0), (0, style.invert-width), stroke: 0.5pt)
            } else {
                line((-style.invert-height, 0), (0, -style.invert-width), stroke: 0.5pt)
                line((0, 0), (0, -style.invert-width), stroke: 0.5pt)
            }
        } else if invert == true {
            let cx = if dir == "east" { r } else if dir == "west" { -r } else { 0 }
            let cy = if dir == "north" { r } else if dir == "south" { -r } else { 0 }
            circle((cx, cy), radius: r, fill: white, stroke: 0.5pt)
        }
    }

    // Component call
    component("stub", "l", node, draw: draw, ..args)
}
#let nstub(node, ..params) = stub(node, ..params, dir: "north")
#let sstub(node, ..params) = stub(node, ..params, dir: "south")
#let estub(node, ..params) = stub(node, ..params, dir: "east")
#let wstub(node, ..params) = stub(node, ..params, dir: "west")
