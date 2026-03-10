export const landingContent = {
  metadata: {
    title: "TremTec - Build Trustworthy Software Faster",
  },
  navbar: {
    logo: "TremTec",
    links: [
      { label: "Home", href: "/" },
      { label: "Services", href: "/services" },
      { label: "Products", href: "/products" },
      { label: "Blog", href: "/blog" },
    ],
    cta: {
      login: "Log in",
      getStarted: "Get Started",
    },
  },
  hero: {
    title: "Flexible Engineering. Built for Your Pace.",
    description:
      "Bring the right team to your project when you need them. No fixed roles. No long-term commitments. Just experts who scale with your scope, timeline, and budget—then hand off complete ownership to your team.",
    cta: {
      demo: "Start Your Project",
      howItWorks: "See How It Works",
    },
    imageAlt: "Flexible engineering teams for high-growth companies",
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
    badge: "Flexible Resourcing",
    title: "Three ways we scale with your project",
    description:
      "Whether you need a quick SDLC analysis, hands-on implementation with a dedicated squad, or ongoing mentoring as you master new practices—we flex our team to match your scope, timeline, and constraints.",
    items: [
      {
        id: "implementation",
        title: "Implementation Squad",
        description:
          "A dedicated team (1 lead + 1–3 engineers) that builds reproducible SDLCs and transfers complete knowledge to your team. After 4–8 weeks, you operate independently. No ongoing retainer.",
        icon: "heroicons:cpu-chip",
        bgIcon: "heroicons:code-bracket-square",
        linkText: "View pricing",
      },
      {
        id: "fractional-cto",
        title: "Fractional CTO",
        description:
          "1–2 week analysis uncovering your actual bottlenecks, velocity drivers, and a clear roadmap forward. Fast clarity without a year-long engagement.",
        icon: "heroicons:chart-bar-square",
        bgIcon: "heroicons:magnifying-glass",
      },
      {
        id: "mentoring",
        title: "Mentoring & Coaching",
        description:
          "Ongoing partnership (month-to-month) where your team steers and we coach. Monthly strategy sessions, on-demand guidance, and continuous pattern optimization.",
        icon: "heroicons:academic-cap",
        badges: [
          "AI Mastery",
          "Architecture Guidance",
          "Performance Optimization",
        ],
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
    badge: "How We Work",
    title: "Flexible teams. Flexible engagement.",
    description:
      "We customize our approach to match your constraints—scope, timeline, location, team composition, and level of involvement.",
    features: [
      {
        title: "Right People, Right Time",
        description:
          "We allocate architects, engineers, DevOps, or AI specialists based on what your project actually needs—not a preset squad.",
        icon: "heroicons:users",
      },
      {
        title: "Your Constraints Matter",
        description:
          "Remote, embedded, hybrid. Part-time, full-time. Short sprint, long engagement. We flex to your reality.",
        icon: "heroicons:adjustments-horizontal",
      },
      {
        title: "Knowledge Transfer Built-In",
        description:
          "Your team owns the outcome. We document patterns, mentor as we build, and hand off complete understanding—not just code.",
        icon: "heroicons:shield-check",
      },
    ],
  },
  about: {
    title: "We scale resources to match your reality.",
    description:
      "Not every project needs a fractional CTO. Not every team wants a long-term dependency. We bring flexible squads that teach, implement, and hand off—so you own the outcome and operate independently.",
    mission: {
      title: "Our Mission",
      paragraphs: [
        "Build trustworthy software faster, with your team in control. We bring expertise when you need it, scale resources to match your constraints, and ensure complete knowledge transfer so you can operate independently.",
        "We believe high-growth companies deserve engineering partners who flex with them—not vendors who trap them in retainers. Speed that sticks. Patterns you understand. Teams that grow. That's TremTec.",
      ],
    },
  },
  cta: {
    title: "Ready to flex your engineering?",
    description:
      "Let's talk about your project. We'll listen to your constraints, scope, and timeline—then propose a flexible staffing model that actually fits your reality.",
    button: "Schedule a Call",
    features: [
      {
        title: "No Fixed Roles",
        description:
          "We don't force a standard squad. We allocate based on what your project actually needs.",
        icon: "heroicons:users",
      },
      {
        title: "Your Team Owns It",
        description:
          "Knowledge transfer, not hand-off. After engagement, your team operates independently with complete understanding.",
        icon: "heroicons:shield-check",
      },
    ],
  },
  footer: {
    description:
      "Flexible engineering teams that scale with your project. Your team in control.",
    sections: [
      {
        title: "Services",
        links: [
          { label: "Implementation Squad", href: "#services" },
          { label: "Fractional CTO", href: "#services" },
          { label: "Mentoring & Coaching", href: "#services" },
          { label: "Pricing", href: "/pricing" },
        ],
      },
      {
        title: "Company",
        links: [
          { label: "About Us", href: "#about" },
          { label: "How We Work", href: "#methodology" },
          { label: "Blog", href: "/blog" },
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
