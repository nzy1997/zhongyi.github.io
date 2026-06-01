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

#let cvheading_local(info, uservars) = {
  align(center)[
    = #info.personal.name
    #jobtitletext(info, uservars)
    #let profiles = (
      if "nameNative" in info.personal.keys() and info.personal.nameNative != none {
        box[#info.personal.nameNative]
      },
      box(link("mailto:" + info.personal.email)),
      if info.personal.url != none {
        box(link(info.personal.url)[#info.personal.url.split("//").at(1)])
      }
    ).filter(it => it != none)
    #if info.personal.profiles.len() > 0 {
      for profile in info.personal.profiles {
        profiles.push(box(link(profile.url)[#profile.url.split("//").at(1)]))
      }
    }
    #set text(font: uservars.bodyfont, weight: "medium", size: uservars.fontsize * 1)
    #pad(x: 0em)[
      #profiles.join([#sym.space.en #sym.diamond.filled #sym.space.en])
    ]
  ]
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

#let cvwork_local(info, title: "Work Experience", isbreakable: true) = {
  if info.work != none {block[
    == #title
    #for w in info.work {
      block(width: 100%, breakable: isbreakable)[
        #if w.url != none [
          *#link(w.url)[#w.organization]* #h(1fr) *#w.location* \
        ] else [
          *#w.organization* #h(1fr) *#w.location* \
        ]
      ]
      let index = 0
      for p in w.positions {
        if index != 0 {v(0.6em)}
        block(width: 100%, breakable: isbreakable, above: 0.6em)[
          #let start = utils.strpdate(p.startDate)
          #let end = utils.strpdate(p.endDate)
          #text(style: "italic")[#p.position] #h(1fr)
          #utils.daterange(start, end) \
          #for hi in p.highlights [
            - #eval(hi, mode: "markup")
          ]
        ]
        index = index + 1
      }
    }
  ]}
}

#let project_entries(info, section) = {
  if info.projects == none {
    ()
  } else {
    info.projects.filter(project => project.homepageSection == section)
  }
}

#let project_date_single(project) = {
  utils.strpdate(project.startDate)
}

#let cvprojectgroup(info, section, title) = {
  let entries = project_entries(info, section)
  if entries != () and entries.len() > 0 {block[
    == #title
    #for project in entries {
      block(width: 100%, breakable: true)[
        #if project.url != none [
          *#link(project.url)[#project.name]* \
        ] else [
          *#project.name* \
        ]
        #if section == "software" [
          #project.homepageMeta \
        ] else if section == "talks" [
          #text(style: "italic")[#project.affiliation] #h(1fr) #project_date_single(project) \
        ] else [
          #text(style: "italic")[#project.affiliation] \
        ]
        #for hi in project.highlights [
          - #eval(hi, mode: "markup")
        ]
      ]
    }
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

#cvheading_local(cvdata, uservars)
#cvresearchinterests(cvdata)
#cveducation(cvdata)
#cvwork_local(cvdata, title: "Research Positions")
#cvpublications_academic(cvdata)
#cvprojectgroup(cvdata, "software", "Open Source Contributions")
#cvprojectgroup(cvdata, "talks", "Talks")
#cvawards(cvdata, title: "Awards")
#endnote(uservars)
