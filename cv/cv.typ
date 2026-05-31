#import "@preview/imprecv:1.0.1": *

#let cvdata = yaml("cv.yml")

#let uservars = (
  headingfont: "Times New Roman",
  bodyfont: "Times New Roman",
  codefont: "Menlo",
  fontsize: 10.5pt,
  linespacing: 5pt,
  sectionspacing: 0.15em,
  showAddress: true,
  showNumber: true,
  showTitle: true,
  headingsmallcaps: false,
  sendnote: false,
)

#let customrules(doc) = {
  set page(
    paper: "a4",
    numbering: "1",
    number-align: center,
    margin: (x: 1.5cm, y: 1.3cm),
  )

  doc
}

#let cvinit_local(doc) = {
  doc = setrules(uservars, doc)
  doc = showrules(uservars, doc)
  doc = customrules(doc)

  doc
}

#let cvresearchinterests(info, title: "Research Interests") = {
  if info.researchInterests != none {block[
    == #title
    - #info.researchInterests.join(", ")
  ]}
}

#let publication_entry(pub) = [
  #eval(pub.authors, mode: "markup").
  #if pub.url != none [
    #link(pub.url)[#pub.title.]
  ] else [
    #pub.title.
  ]
  #eval(pub.venue, mode: "markup")
]

#let cvpublications_academic(info, title: "Publications & Preprints") = {
  if info.publicationEntries != none {block[
    == #title
    #set text(size: 9.5pt)
    #set enum(numbering: "1.", indent: 1.4em, body-indent: 0.5em, spacing: 0.5em)
    #for pub in info.publicationEntries [
      + #publication_entry(pub)
    ]
  ]}
}

#let endnote(uservars) = {
  if uservars.sendnote {
    place(
      bottom + right,
      dx: 9em,
      dy: -7em,
      rotate(-90deg, block[
        #set text(size: 4pt, font: "Menlo", fill: silver)
        \*This document was last updated on #datetime.today().display("[year]-[month]-[day]") using #strike(stroke: 1pt)[LaTeX] #underline(link("https://typst.app/home")[*Typst*]). \
      ])
    )
  } else {
    place(
      bottom + right,
      block[
        #set text(size: 5pt, font: "Menlo", fill: silver)
        \*This document was last updated on #datetime.today().display("[year]-[month]-[day]") using #strike(stroke: 1pt)[LaTeX] #underline(link("https://typst.app/home")[*Typst*]). \
      ]
    )
  }
}

#show: doc => cvinit_local(doc)

#cvheading(cvdata, uservars)
#cvresearchinterests(cvdata)
#cveducation(cvdata)
#cvwork(cvdata, title: "Research Positions")
#cvpublications_academic(cvdata)
#cvprojects(cvdata, title: "Software & Talks")
#cvawards(cvdata, title: "Awards")
#endnote(uservars)
