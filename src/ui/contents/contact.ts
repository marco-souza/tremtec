export interface TrustSignal {
  icon: "clock" | "shield" | "lock";
  title: string;
  description: string;
  color: "primary" | "secondary" | "accent";
}

export interface ContactContent {
  metadata: {
    title: string;
    description: string;
  };
  hero: {
    title: string;
    subtitle: string;
  };
  form: {
    fields: {
      name: { label: string; placeholder: string; required: boolean };
      email: { label: string; placeholder: string; required: boolean };
      company: { label: string; placeholder: string; required?: boolean };
      service: {
        label: string;
        placeholder: string;
        required: boolean;
        options: { value: string; label: string }[];
      };
      message: {
        label: string;
        placeholder: string;
        required: boolean;
        hint: string;
      };
    };
    submit: string;
    success: string;
    error: string;
  };
  trustSignals: TrustSignal[];
}

export const contactContent: ContactContent = {
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
      color: "primary",
    },
    {
      icon: "shield",
      title: "No Obligation",
      description: "Free consultation, no pressure",
      color: "secondary",
    },
    {
      icon: "lock",
      title: "Privacy Protected",
      description: "Your information is safe with us",
      color: "accent",
    },
  ],
};
