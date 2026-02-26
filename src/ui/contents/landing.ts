export const landingContent = {
  metadata: {
    title: "TremTec - Build Trustworthy Software Faster",
  },
  navbar: {
    logo: "TremTec",
    links: [
      { label: "Services", href: "#services" },
      { label: "Methodology", href: "#methodology" },
      { label: "About", href: "#about" },
    ],
    cta: {
      login: "Log in",
      getStarted: "Get Started",
    },
  },
  hero: {
    title: "Build trustworthy software faster.",
    description:
      "Your team can move faster without sacrificing quality. We teach you to master AI—and every other tool in your stack—to create SDLCs that sustain velocity without burning people out.",
    cta: {
      demo: "Let's Talk",
      howItWorks: "How it works?",
    },
    imageAlt: "Build trustworthy software faster",
  },
  trustedBy: {
    title: "Trusted by high-growth companies",
    companies: ["PodCodar", "Devopness", "Plantar Me", "MeHabilite"],
  },
  testimonials: {
    title: "Proven Client Wins",
    description:
      "Real outcomes from high-growth companies we've partnered with",
    items: [
      {
        company: "MeHabilite",
        service: "AI-based outsourcing",
        outcome: "75% reduction in Time-to-Market",
        icon: "heroicons:rocket-launch",
      },
      {
        company: "PodCodar",
        service: "Outsourcing & training",
        outcome: "40+ people qualified from zero to market in 3 years",
        icon: "heroicons:users",
      },
      {
        company: "Devopness",
        service: "Outsourcing + Engineering Excellence Consulting",
        outcomes: ["56% cheaper MVP", "36% faster delivery"],
        icon: "heroicons:chart-bar-square",
      },
    ],
  },
  services: {
    badge: "Build with trust, not shortcuts.",
    title: "Three ways to master your development process",
    description:
      "Whether you need hands-on help building with AI, a deep diagnostic of what's slowing you down, or ongoing mentorship—we customize our approach to help your team ship faster without the technical debt.",
    items: [
      {
        id: "implementation",
        title: "Ship with Confidence",
        description:
          "We implement reproducible SDLCs that combine AI and human expertise. Your team learns patterns you can sustain independently.",
        icon: "heroicons:cpu-chip",
        bgIcon: "heroicons:code-bracket-square",
        linkText: "Learn more",
      },
      {
        id: "diagnostics",
        title: "Know Your Real Bottlenecks",
        description:
          "Deep analysis reveals where you're actually slow—and it's rarely what you think. Clear roadmap to sustainable velocity.",
        icon: "heroicons:chart-bar-square",
        bgIcon: "heroicons:magnifying-glass",
      },
      {
        id: "mentoring",
        title: "Build Engineering Excellence",
        description:
          "Ongoing coaching that teaches your team to work symbiotically with AI and modern tools. From reactive to proactive. From survival to mastery.",
        icon: "heroicons:academic-cap",
        badges: ["Code Reviews", "Architecture", "Best Practices"],
      },
    ],
    codeSnippet: `
defmodule HighPerformanceTeam do
  use Expertise

  def scale(team) do
    team
    |> Mentorship.boost()
    |> Process.optimize()
    |> Output.maximize()
  end
end`,
  },
  methodology: {
    badge: "Methodology",
    title: "We focus on sustainable speed.",
    description:
      "Pragmatic processes that adapt to your reality, not the other way around.",
    features: [
      {
        title: "Reality-First Process",
        description:
          "Your process adapts to reality. Not the other way around.",
        icon: "heroicons:adjustments-horizontal",
      },
      {
        title: "Continuous Validation",
        description:
          "Short feedback loops that prove what works before you scale it.",
        icon: "heroicons:bolt",
      },
      {
        title: "Reproducible & Auditable",
        description:
          "Every decision documented. Every process repeatable. Trust built in from day one.",
        icon: "heroicons:shield-check",
      },
    ],
  },
  about: {
    title: "We believe engineering is about people, not just tools.",
    description:
      "AI is powerful. But it's dangerous without humans who understand responsibility, quality, and sustainability. We help teams master AI as a tool—not a replacement. Build software that's fast, trustworthy, and maintainable. Your people stay energized. Your code stays clean.",
    mission: {
      title: "Our Mission",
      paragraphs: [
        "Build trustworthy software faster. We help your team master AI—not replace humans with it—and create SDLCs that actually sustain.",
        "We believe that technology should be an engine of growth, not a source of frustration. Our mission is to liberate engineering teams from the chaos of disorganized processes and technical debt, empowering them to build world-class products with confidence and speed.",
      ],
    },
  },
  cta: {
    title: "Your team deserves better than chaos.",
    description:
      "30 minutes. No pitch. We'll map your biggest bottleneck and show you one concrete next step to sustainable velocity.",
    button: "Let's Talk",
    features: [
      {
        title: "Slow Time-to-Market",
        description:
          "Your competition won't wait. Every launch delay is lost revenue and missed opportunity.",
        icon: "heroicons:rocket-launch",
      },
      {
        title: "Lack of Seniority",
        description:
          "Absence of technical leadership leads to rework, bugs, and costly architectural decisions.",
        icon: "heroicons:users",
      },
    ],
  },
  footer: {
    description:
      "Build trustworthy software faster. With your team in control.",
    sections: [
      {
        title: "Services",
        links: [
          { label: "Implementation", href: "#services" },
          { label: "Diagnostics", href: "#services" },
          { label: "Mentoring", href: "#services" },
        ],
      },
      {
        title: "Company",
        links: [
          { label: "About Us", href: "#about" },
          { label: "Contact", href: "#contact" },
        ],
      },
      {
        title: "Connect",
        socials: [
          {
            label: "GitHub",
            icon: "mdi:github",
            href: "https://github.com/tremtec",
          },
          {
            label: "LinkedIn",
            icon: "mdi:linkedin",
            href: "https://www.linkedin.com/company/tremtec/",
          },
        ],
      },
    ],
    rights: "All rights reserved by TremTec.",
    legal: [
      { label: "Privacy Policy", href: "#" },
      { label: "Terms of Service", href: "#" },
    ],
  },
};
