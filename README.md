# crawlx
Project of a Crawler using Elixir + Phoenix to track products stock and notify you when the product has changed in price or availability. For study purposes only.

## Features
* Use of Phoenix LiveView on all interface pages (avoiding the need to keep updating the page manually).
* Use of MySQL Database for store the items retrieved by spiders.
* Spider status monitoring (you can check if the target page is available or spider is running).
* Integration with Telegram.
* Product price history.
* Manage all Crawly spiders via the web interface (start spider, stop spider).

## Usage
For integrate your spider with this project, you can follow the tutorial from [Crawly Documentation](https://hexdocs.pm/crawly/tutorial.html#our-first-spider). The name of Spider module must be `Crawler.Spider.<name>` and your spider must return an item in the following format:

```
%{
  title: "Product Title",
  price: "R$ 1.300,90",
  url: "https://localhost"
}
```

After the spider has been created, you can add your spider into `@crawler_spiders` list (mainly used for Cron jobs and Dashboard), located in the `crawler.ex` file.

## Demonstration
![image](https://user-images.githubusercontent.com/36571229/113385935-7b9d1380-935f-11eb-8845-cf9f29de161a.png)

## Database
### crawlx.products
```
create table products
(
    id          int auto_increment
        primary key,
    url_hash    varchar(32)  not null,
    spider_name varchar(64)  not null,
    title       varchar(256) not null,
    url         varchar(256) null,
    updated_at  datetime     not null,
    constraint products_url_hash_spider_name_uindex
        unique (url_hash, spider_name)
);
```
### crawlx.products_price_hist
```
create table products_price_hist
(
    id         int auto_increment
        primary key,
    product_id int           not null,
    price      decimal(6, 2) not null,
    date       datetime      not null,
    constraint products_price_hist_products_id_fk
        foreign key (product_id) references products (id)
);
```

## Dependencies
* [Crawly](https://hexdocs.pm/crawly)
* [Phoenix](https://hexdocs.pm/phoenix)
* [Telegex](https://hexdocs.pm/telegex)
