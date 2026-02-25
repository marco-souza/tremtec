export const landingContent = {
  metadata: {
    title: "TremTec - Your Software on Track!",
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
    title: "Your Software on Track!",
    description:
 "Unlock your product's true potential. We combine technical excellence and speed to create software that users love and developers are proud to build.",
    cta: {
      demo: "Book a Demo!",
      howItWorks: "How it works?",
    },
    imageAlt: "A Trem to your Tech Team",
  },
  trustedBy: {
    title: "Trusted by high-growth companies",
    companies: ["PodCodar", "Devopness", "Plantar Me", "MeHabilite"],
  },
  services: {
    badge: "Move fast without breaking things",
    title: "Structure that turns potential into results!",
    description:
 "Deploy people, processes, and tools that accelerate your development cycle, focusing on continuous delivery and automation.",
    items: [
      {
        id: "implementation",
        title: "Implementation",
        description:
 "TremTec implements best practices and tools to streamline your development process and accelerate delivery.",
        icon: "heroicons:cpu-chip",
        bgIcon: "heroicons:code-bracket-square",
        linkText: "Learn more",
      },
      {
        id: "diagnostics",
        title: "Diagnostics",
        description:
 "We analyze your current development process, tools, and team dynamics to identify bottlenecks",
        icon: "heroicons:chart-bar-square",
        bgIcon: "heroicons:magnifying-glass",
      },
      {
        id: "mentoring",
        title: "Mentoring",
        description:
 "If needed, we provide ongoing mentorship and support to ensure your team continues to improve and adapt to changing needs.",
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
    title: "Methodology",
    description:
 "We combine deep technical expertise and pragmatic product vision.",
    features: [
      {
        title: "Agile Integration",
        description:
 "Adaptable processes that mold to your business reality, not the other way around.",
        icon: "heroicons:adjustments-horizontal",
      },
      {
        title: "Rapid Iteration",
        description:
 "Short feedback cycles to validate hypotheses and deliver value continuously.",
        icon: "heroicons:bolt",
      },
      {
        title: "Quality Assurance",
        description: "Test automation and robust CI/CD from project day one.",
        icon: "heroicons:shield-check",
      },
    ],
  },
  about: {
    title: "About TremTec",
    description:
 "Born with the purpose of closing the gap between software engineering and business value.",
    impact: {
      title: "Our Impact",
      stats: [
        {
          title: "Years Experience",
          value: "15+",
          desc: "High-scale environments",
          color: "text-primary",
        },
        {
          title: "Projects Delivered",
          value: "50+",
          desc: "Across 4 continents",
          color: "text-secondary",
        },
        {
          title: "Teams Scaled",
          value: "20+",
          desc: "From Seed to Series B",
          color: "text-accent",
        },
      ],
    },
    mission: {
      title: "Our Mission",
      paragraphs: [
 "We believe that technology should be an engine of growth, not a source of frustration. Our mission is to liberate engineering teams from the chaos of disorganized processes and technical debt, empowering them to build world-class products with confidence and speed.",
 "We don't just fix code; we cultivate high-performance cultures. By bridging the gap between business goals and technical execution, we transform struggling development squads into autonomous, value-generating powerhouses that drive the company forward.",
      ],
    },
  },
  cta: {
    title: "Ready to transform your development process?",
    description:
 "We will talk for 30 minutes to map your biggest development bottlenecks, no strings attached.",
    button: "Let's book a call!",
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
 "Your strategic engineering partner for scaling high-performance technical teams.",
    sections: [
      {
        title: "Services",
        links: [
          { label: "Outsourcing", href: "#services" },
          { label: "Consulting", href: "#services" },
          { label: "Diagnostics", href: "#services" },
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
