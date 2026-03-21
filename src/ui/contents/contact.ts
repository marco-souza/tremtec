export const contactContent = {
  metadata: {
    title: "Contact Us - TremTec",
    description:
      "Get in touch with TremTec. Let's discuss your engineering challenges.",
  },
  hero: {
    title: "Let's Build Something Great Together",
    subtitle:
      "Tell us about your engineering challenges. We'll respond within 24 hours.",
  },
  form: {
    fields: {
      name: {
        label: "Full Name",
        placeholder: "Your name",
        required: true,
      },
      email: {
        label: "Email",
        placeholder: "you@company.com",
        required: true,
      },
      company: {
        label: "Company",
        placeholder: "Company (optional)",
        required: false,
      },
      service: {
        label: "Service Interest",
        placeholder: "Select a service...",
        required: true,
        options: [
          { value: "implementation", label: "Implementation Squad" },
          { value: "diagnostics", label: "Fractional CTO" },
          { value: "mentoring", label: "Mentoring & Coaching" },
          { value: "other", label: "Other / Not sure" },
        ],
      },
      message: {
        label: "Message",
        placeholder: "Tell us about your project...",
        required: true,
        hint: "Minimum 10 characters",
      },
    },
    submit: "Start the Conversation",
    success: "Thanks! We'll be in touch within 24 hours.",
    error:
      "Something went wrong. Please try again or email us at hello@tremtec.com",
  },
  trustSignals: [
    {
      icon: "clock",
      title: "24h Response",
      description: "We reply within one business day",
    },
    {
      icon: "shield",
      title: "No Obligation",
      description: "Free consultation, no pressure",
    },
    {
      icon: "lock",
      title: "Privacy Protected",
      description: "Your information is safe with us",
    },
  ],
};
