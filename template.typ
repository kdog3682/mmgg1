#import "@local/typkit:0.1.0": *
#import "@local/typkit:0.1.0"
#import "@local/hanzi:0.1.0"

#let spaced-letters(s, spacing: 3pt, ..style) = {
  let characters = split(s).map(text.with(..style.named()))
  return characters.join(h(spacing))
}
#let flex-1(..sink) = {
    let flat(arg) = {
        if is-array(arg) {
            arg.join()
        } else {
            arg
        }
    }

    let apart(col, row, length: none) = {
        if col == 0 {
            left  + horizon
        } else if col == length - 1 {
            right + horizon
        } else {
            center + horizon
        }
    }

    let alignments = (
        "apart": apart
    )

    let args = sink.pos().map(flat)
    let length = args.len()
    let align = alignments.at(sink.named().at("align", default: "apart")).with(length: length)
    return table(columns: (1fr,) * length, align: align, stroke: none, ..args)
}

#let markup(file, module) = {
    let doc = eval(read(file), mode: "markup", scope: dictionary(module))
    return doc
}

#let mmgg-template(file, title, ..sink) = {

    let doc = markup(file, typkit)
    let footer-title = [猫猫和狗狗的故事]
    let base = (
      footer-title: footer-title,
      font-size: 12pt,
      title: "placeholder-title",
      width: 85%,
    )

    let kwargs = merge-dictionary(base, sink.named())
    let cat = boxed(image("assets/cat.png"), size: 20)
    let dog = boxed(image("assets/dog.png"), size: 20)

    // let author = sm-text("作家：Kevin Lee (李路)")
    let chinese = sm-text("作家：李路")
    let english = text("(Kevin Lee)", size: 0.6em)
    let author = stack(dir: ltr, spacing: 5pt, chinese, english)

    let margin = (
      top: 1in,
      left: 1in,
      right: 1in,
      bottom: 1.25in,
    )

    // set page(footer-descent: 0pt)
    // we want the footer to descend a little bit
    set page(footer: context {
      let end = counter(page).final().at(0)
      counter(page).display(number => {
        let num = sm-text(number)
        let ft = sm-text(kwargs.footer-title)
        if number == 1 {
          flex-1((cat, dog).join(""), [— #num —], ft)
        } 
        else if number == end {
          flex-1((dog, cat).join(""), [— #num —], author)
        } 
        else {
            if is-odd(number) {
              flex-1(cat, [— #num —], dog)
            } else {
              flex-1(dog, [— #num —], cat)
            }
        }
      })
    })


    set smartquote(enabled: false)
    set page(paper: "us-letter", margin: margin)
    set text(font: "Noto Serif CJK SC", lang: "zh")
    set text(size: kwargs.font-size)
    set par(leading: 1.1em)
    show par: set block(spacing: 20pt)

    // show "。": hanzi.marks.period
    // show "？": hanzi.marks.question
    // show "！": hanzi.marks.exclam
    // show "，": hanzi.marks.comma
    // show "…" : hanzi.marks.ellipses

    let smaller = it => text(size: 0.8em, it)
    show "Alice":  smaller
    show "Charlie":  smaller
    show "Emily":  smaller
    show "Sara":  smaller
    // not showing :
    // not showing ;
    // not showing (
    // not showing )
    // not showing [
    // not showing ]
    // not showing {
    // not showing }
    // not showing %

    centered(spaced-letters(title, size: 2em, weight: "bold"))
    v(-10pt)
    line(length: 100%, stroke: 0.25pt)
    v(20pt)
    block({
        doc
    }, width: kwargs.width)
}

// #mmgg-template("morning_walk/v4.typ", "早晨散步", width: 75%) // WORKS
// #mmgg-template("sushi_party/v1.typ", "和朋友吃寿司", width: 75%)
