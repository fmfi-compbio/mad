# Use official Jekyll image
FROM jekyll/jekyll:4.2.2

# Set working directory
WORKDIR /srv/jekyll

# Copy Gemfile first (better layer caching)
COPY Gemfile ./

# Install bundler
RUN gem install bundler

# Install dependencies
RUN bundle install

# Copy the rest of the site
COPY . .

# Expose port 4000
EXPOSE 4000

# Start the Jekyll development server with live reloading
CMD ["bundle", "exec", "jekyll", "serve", "--baseurl", "", "--host", "0.0.0.0", "--watch"]
