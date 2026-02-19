export const routes = {
  private: {
    dashboard: "/dashboard",
  },
  public: {
    home: "/",
    login: "/login",
    logout: "/api/auth/logout",
  },
} as const;

export const isPrivateRoute = (path: string) => {
  return Object.values(routes.private).some((privatePath) =>
    path.startsWith(privatePath),
  );
};

export const isPublicRoute = (path: string) => {
  return Object.values(routes.public).some((publicPath) =>
    path.startsWith(publicPath),
  );
};
