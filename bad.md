
# 1. prep < section

Missing type field

```
2.1.7 :001 > Prep.create!
   (0.3ms)  BEGIN
  SQL (0.9ms)  INSERT INTO "sections" ("created_at", "updated_at") VALUES ($1, $2) RETURNING "id"  [["created_at", "2016-04-17 19:41:22.437636"], ["updated_at", "2016-04-17 19:41:22.437636"]]
   (0.5ms)  COMMIT
 => #<Prep id: 1, name: nil, slug: nil, created_at: "2016-04-17 19:41:22", updated_at: "2016-04-17 19:41:22", order: nil> 
2.1.7 :002 > Prep.all.to_sql
 => "SELECT \"sections\".* FROM \"sections\"" 
```

# 2. useless endpoints on prep

`resources :prep, controller: 'preps', :only => [:index, :new, :create, :show, :edit, :update] do `

but controller only has `show` action

# 