defmodule TremtecWeb.PublicPages.HomeLive do
  use TremtecWeb, :live_view

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: gettext("Home"))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={assigns[:current_scope]}>
      <!-- Hero Section -->
      <div class="relative overflow-hidden bg-base-100 pt-16 pb-12 sm:pb-16 md:pb-24 lg:pb-32">
        <div class="mx-auto max-w-7xl px-6 md:px-8 relative z-10">
          <div class="flex flex-col md:grid md:grid-cols-12 md:gap-x-8 md:items-center md:py-12">
            <!-- Image Column (Visible only on lg+) -->
            <div class="hidden lg:block w-full lg:order-2 lg:col-span-6">
              <div class="relative p-2 md:p-4 hover:scale-[1.02] duration-500">
                <img
                  src={~p"/images/hero.png"}
                  alt={gettext("A Trem to your Tech Team")}
                  class="rounded-md w-full h-auto object-cover"
                />
              </div>
            </div>
            
    <!-- Content Column -->
            <div class="w-full order-2 lg:order-1 md:col-span-12 lg:col-span-6 text-center lg:text-left">
              <h1 class="text-4xl font-extrabold tracking-tight text-base-content sm:text-6xl mb-6">
                {gettext("hero title")}
              </h1>
              <p class="mt-6 text-lg leading-8 text-base-content/70 max-w-2xl mx-auto lg:mx-0">
                {gettext("hero subtitle")}
              </p>
              <div class="mt-10 flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4 sm:gap-x-6">
                <a href="#contact" class="btn btn-primary btn-lg w-full sm:w-auto px-8">
                  {gettext("get started")}
                </a>
                <a
                  href="#services"
                  class="btn btn-ghost btn-lg w-full sm:w-auto text-sm font-semibold leading-6 text-base-content"
                >
                  {gettext("how it works")} <span aria-hidden="true">→</span>
                </a>
              </div>
            </div>
          </div>
        </div>
        
    <!-- Background Gradient Blur -->
        <div class="absolute top-0 left-1/2 -translate-x-1/2 -z-10 w-full h-full max-w-7xl opacity-30 pointer-events-none">
          <div class="absolute top-[20%] left-[10%] w-72 h-72 bg-primary/30 rounded-full blur-3xl mix-blend-multiply animate-blob" />
          <div class="absolute top-[20%] right-[10%] w-72 h-72 bg-secondary/30 rounded-full blur-3xl mix-blend-multiply animate-blob animation-delay-2000" />
          <div class="absolute -bottom-8 left-[30%] w-72 h-72 bg-accent/30 rounded-full blur-3xl mix-blend-multiply animate-blob animation-delay-4000" />
        </div>
      </div>
      
    <!-- Trust Section -->
      <div class="py-12 bg-base-100 border-y border-base-200/50">
        <div class="mx-auto max-w-7xl px-6 md:px-8">
          <p class="text-center text-sm font-semibold text-base-content/40 uppercase tracking-widest mb-8">
            {gettext("Trusted by high-growth companies")}
          </p>

          <div class="flex justify-center items-center gap-x-12 gap-y-8 grayscale opacity-50 flex-wrap">
            <.trust_logo name="ACME Corp" />
            <.trust_logo name="Stark Ind" />
            <.trust_logo name="Globex" />
            <.trust_logo name="Soylent" />
            <.trust_logo name="Umbrella" />
          </div>
        </div>
      </div>
      
    <!-- Bento Grid Services -->
      <.landing_section id="services" class="bg-base-200">
        <.section_header
          title={gettext("problem title")}
          subtitle={gettext("solution title")}
          description={gettext("solution subtitle")}
        />

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 auto-rows-[minmax(300px,_auto)]">
          <!-- Card 1: Strategic Outsourcing (Span 2) -->
          <.bento_card class="md:col-span-2" hover_border="primary">
            <div class="absolute top-0 right-0 p-8 opacity-10 group-hover:opacity-20 transition-opacity">
              <.icon name="hero-code-bracket-square" class="w-48 h-48 text-primary" />
            </div>

            <div class="relative z-10 flex flex-col h-full justify-between">
              <.service_card_content
                icon="hero-cpu-chip"
                title={gettext("implementation")}
                description={gettext("implementation description")}
                color="primary"
              >
                <:extra>
                  <div class="mt-8">
                    <span class="text-sm font-medium text-primary group-hover:translate-x-1 transition-transform inline-flex items-center gap-1">
                      {gettext("Learn more")} <.icon name="hero-arrow-right" class="w-4 h-4" />
                    </span>
                  </div>
                </:extra>
              </.service_card_content>
            </div>
          </.bento_card>
          
    <!-- Card 2: Diagnostics (Span 1) -->
          <.bento_card class="md:col-span-1" hover_border="secondary">
            <div class="absolute -bottom-8 -right-8 p-8 opacity-10 group-hover:opacity-20 transition-opacity">
              <.icon name="hero-magnifying-glass" class="w-40 h-40 text-secondary" />
            </div>

            <div class="relative z-10">
              <.service_card_content
                icon="hero-chart-bar-square"
                title={gettext("diagnostics")}
                description={gettext("diagnostics description")}
                color="secondary"
                title_class="text-xl"
              />
            </div>
          </.bento_card>
          
    <!-- Card 3: Mentorship (Span 3 - Full Width) -->
          <.bento_card
            class="md:col-span-3 flex flex-col md:flex-row gap-8 items-center"
            hover_border="accent"
          >
            <div class="flex-1 relative z-10">
              <.service_card_content
                icon="hero-academic-cap"
                title={gettext("mentoring")}
                description={gettext("mentoring description")}
                color="accent"
              >
                <:extra>
                  <div class="mt-6 flex flex-wrap gap-4">
                    <div class="badge badge-outline p-3">{gettext("Code Reviews")}</div>
                    <div class="badge badge-outline p-3">{gettext("Architecture")}</div>
                    <div class="badge badge-outline p-3">{gettext("Best Practices")}</div>
                  </div>
                </:extra>
              </.service_card_content>
            </div>

            <div class="flex-1 w-full bg-base-200/50 rounded-xl p-2 sm:p-4 md:p-6 font-mono text-xs md:text-sm text-base-content/80 border border-base-300 shadow-inner">
              <!-- Mock Code Block -->
              <div class="flex gap-2 mb-4">
                <div class="w-3 h-3 rounded-full bg-error"></div>
                <div class="w-3 h-3 rounded-full bg-warning"></div>
                <div class="w-3 h-3 rounded-full bg-success"></div>
              </div>
              <pre><code>defmodule HighPerformanceTeam do
      use Expertise

      def scale(team) do
        team
        |> Mentorship.boost()
        |> Process.optimize()
        |> Output.maximize()
      end
      end</code></pre>
            </div>
          </.bento_card>
        </div>
      </.landing_section>
      
    <!-- Methodology Section -->
      <.landing_section id="methodology" class="bg-base-100 overflow-hidden">
        <div class="mx-auto grid max-w-2xl grid-cols-1 gap-x-8 gap-y-16 sm:gap-y-20 md:mx-0 md:max-w-none md:grid-cols-2">
          <div class="md:pr-8 md:pt-4">
            <div class="md:max-w-lg">
              <.section_header
                title={gettext("Methodology")}
                subtitle={gettext("methodology title")}
                description={gettext("methodology description")}
                align="left"
              />
              <dl class="mt-10 max-w-xl space-y-8 text-base leading-7 text-base-content/70">
                <.methodology_item
                  icon="hero-adjustments-horizontal"
                  title={gettext("Agile Integration")}
                  description={gettext("agile description")}
                />
                <.methodology_item
                  icon="hero-bolt"
                  title={gettext("Rapid Iteration")}
                  description={gettext("iteration description")}
                />
                <.methodology_item
                  icon="hero-shield-check"
                  title={gettext("Quality Assurance")}
                  description={gettext("quality description")}
                />
              </dl>
            </div>
          </div>

          <div class="flex items-start justify-end md:order-last">
            <div class="relative rounded-xl bg-base-200 p-2 ring-1 w-full ring-base-300 md:-ml-4 lg:-ml-0">
              <!-- Abstract Visualization of Process -->
              <div class="relative w-full h-[400px] bg-base-100 rounded-lg overflow-hidden flex items-center justify-center">
                <div class="grid grid-cols-3 gap-8 opacity-80">
                  <.process_step
                    icon="hero-beaker"
                    color_class="text-primary"
                    bg_class="bg-primary/20"
                  />
                  <.process_step
                    icon="hero-code-bracket"
                    color_class="text-secondary"
                    bg_class="bg-secondary/20"
                    delay_class="animation-delay-2000"
                  />
                  <.process_step
                    icon="hero-rocket-launch"
                    color_class="text-accent"
                    bg_class="bg-accent/20"
                    delay_class="animation-delay-4000"
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </.landing_section>
      
    <!-- About Section -->
      <.landing_section id="about" class="bg-base-200">
        <.section_header
          title={gettext("About TremTec")}
          description={gettext("about description")}
          big_title
        />

        <div class="mx-auto grid max-w-7xl gap-8 md:grid-cols-3">
          <!-- Stats Card -->
          <div class="card bg-base-100 shadow-xl border border-base-300">
            <div class="card-body">
              <h3 class="card-title text-primary">{gettext("Our Impact")}</h3>
              <div class="stats stats-vertical sm:stats-horizontal md:stats-vertical shadow bg-transparent">
                <.stat_item
                  title={gettext("Years Experience")}
                  value="15+"
                  desc={gettext("High-scale environments")}
                  value_class="text-primary"
                />
                <.stat_item
                  title={gettext("Projects Delivered")}
                  value="50+"
                  desc={gettext("Across 4 continents")}
                  value_class="text-secondary"
                />
                <.stat_item
                  title={gettext("Teams Scaled")}
                  value="20+"
                  desc={gettext("From Seed to Series B")}
                  value_class="text-accent"
                />
              </div>
            </div>
          </div>
          
    <!-- Mission -->
          <div class="card bg-base-100 shadow-xl border border-base-300 md:col-span-2">
            <div class="card-body">
              <h3 class="card-title text-2xl mb-4">{gettext("Our Mission")}</h3>
              <p class="text-lg leading-relaxed text-base-content/70 mb-4">
                {gettext("mission description")}
              </p>
              <p class="text-lg leading-relaxed text-base-content/70 mb-8">
                {gettext("mission description part 2")}
              </p>
            </div>
          </div>
        </div>
      </.landing_section>
      
    <!-- CTA Section -->
      <div id="contact" class="relative isolate overflow-hidden bg-base-100 py-16 sm:py-24 md:py-32">
        <div class="mx-auto max-w-7xl px-6 md:px-8">
          <div class="mx-auto grid max-w-2xl grid-cols-1 gap-x-8 gap-y-16 md:max-w-none md:grid-cols-2">
            <div class="text-center sm:text-left max-w-xl md:max-w-lg">
              <h2 class="text-3xl font-bold tracking-tight text-base-content sm:text-4xl">
                {gettext("cta title")}
              </h2>
              <p class="mt-4 text-lg leading-8 text-base-content/70">
                {gettext("cta subtitle")}
              </p>
              <div class="mt-6 flex max-w-full gap-x-4">
                <a href="/contact" class="btn btn-primary btn-lg w-full sm:w-auto">
                  {gettext("contact us")}
                </a>
              </div>
            </div>
            <dl class="grid grid-cols-1 gap-x-8 gap-y-10 sm:grid-cols-2 md:pt-2">
              <.cta_item
                icon="hero-rocket-launch"
                title={gettext("missed deadlines")}
                description={gettext("problem subtitle")}
              />
              <.cta_item
                icon="hero-users"
                title={gettext("unmotivated team")}
                description={gettext("unpredictable costs")}
              />
            </dl>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp trust_logo(assigns) do
    ~H"""
    <div class="text-2xl font-bold text-base-content/60">{@name}</div>
    """
  end

  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :description, :string, required: true
  attr :align, :string, default: "center", values: ~w(center left)
  attr :big_title, :boolean, default: false

  defp section_header(assigns) do
    class = if assigns.align == "center", do: "mx-auto text-center", else: "md:max-w-lg"

    assigns = assign(assigns, :class, class)

    ~H"""
    <div class={["max-w-2xl mb-12", @class]}>
      <h2 :if={!@big_title} class="text-base font-semibold leading-7 text-primary">{@title}</h2>
      <h2 :if={@big_title} class="text-3xl font-bold tracking-tight text-base-content sm:text-4xl">
        {@title}
      </h2>
      <p
        :if={@subtitle}
        class="mt-2 text-3xl font-bold tracking-tight text-base-content sm:text-4xl"
      >
        {@subtitle}
      </p>
      <p class="mt-6 text-lg leading-8 text-base-content/70">
        {@description}
      </p>
    </div>
    """
  end

  attr :icon, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: true
  attr :color, :string, required: true
  attr :title_class, :string, default: "text-2xl"
  slot :extra

  defp service_card_content(assigns) do
    color_map = %{
      "primary" => %{bg: "bg-primary/10", text: "text-primary"},
      "secondary" => %{bg: "bg-secondary/10", text: "text-secondary"},
      "accent" => %{bg: "bg-accent/10", text: "text-accent"}
    }

    assigns = assign(assigns, :colors, color_map[assigns.color])

    ~H"""
    <div>
      <div class={["p-3 rounded-xl w-fit mb-6", @colors.bg]}>
        <.icon name={@icon} class={"w-8 h-8 #{@colors.text}"} />
      </div>
      <h3 class={["font-bold text-base-content mb-4", @title_class]}>{@title}</h3>
      <p class="text-base-content/70 text-lg leading-relaxed max-w-lg">
        {@description}
      </p>
      {render_slot(@extra)}
    </div>
    """
  end

  attr :icon, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: true

  defp methodology_item(assigns) do
    ~H"""
    <div class="relative pl-9">
      <dt class="inline font-semibold text-base-content">
        <.icon name={@icon} class="absolute left-1 top-1 h-5 w-5 text-primary" />
        {@title}
      </dt>
      <dd class="inline">{@description}</dd>
    </div>
    """
  end

  attr :icon, :string, required: true
  attr :color_class, :string, required: true
  attr :bg_class, :string, required: true
  attr :delay_class, :string, default: ""

  defp process_step(assigns) do
    ~H"""
    <div class={["flex flex-col items-center gap-4 animate-pulse", @delay_class]}>
      <div class={["w-16 h-16 rounded-2xl flex items-center justify-center", @bg_class]}>
        <.icon name={@icon} class={"w-8 h-8 #{@color_class}"} />
      </div>
      <div class={["h-1 w-12 rounded-full", @bg_class]}></div>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :value, :string, required: true
  attr :desc, :string, required: true
  attr :value_class, :string, default: ""

  defp stat_item(assigns) do
    ~H"""
    <div class="stat place-items-center px-2">
      <div class="stat-title">{@title}</div>
      <div class={["stat-value", @value_class]}>{@value}</div>
      <div class="stat-desc">{@desc}</div>
    </div>
    """
  end

  attr :icon, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: true

  defp cta_item(assigns) do
    ~H"""
    <div class="flex flex-col items-start">
      <div class="rounded-md bg-base-100/5 p-2 ring-1 ring-base-content/10">
        <.icon name={@icon} class="h-6 w-6 text-base-content" />
      </div>
      <dt class="mt-4 font-semibold text-base-content">{@title}</dt>
      <dd class="mt-2 leading-7 text-base-content/70">{@description}</dd>
    </div>
    """
  end
end
