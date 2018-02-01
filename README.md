# 🗄 présentoir

<!-- Object serializer plus some goodies primarily meant to be used in a Rails context -->

Simple Object serializer based on plain Ruby Objects.

Developed for implementing a Presenter pattern in Rails apps,
but has no dependencies and can be used in any ruby program.

Aims to keep it simple by using a minimal API and no DSL,
and instead using plain Ruby classes, in contrast to something like `jBuilder`.

When used in Rails,
it frees up Controllers from having to build data-heavy objects,
and also helps to keep Models free from handling special case and variations of data structures.

It is most usefull when many Views show several pieces of data from different Models,
and their representation should be reused.

A good convention is to always have exactly 1 Presenter per controller action.
This helps with testing as well as providing a JSON-API for your frontend.
For example, for webapps that use client side routing,
it is easy to optionally respond with "only the data" instead of rendering the view with it.

Being forced to explicitly define exactly what data is given to the View
in turn makes them safer to maintain: View-Templates don't automatically get
programmatic access to the database just because we handed them an ActiveRecord object.


The name is a French noun, because all other "presenter" names were already taken
and it luckily fits.

> *présentoir*: Étagère ou autre pièce de mobilier qui sert à mettre en valeur les marchandises, ***à exposer des objets***.  
> — [*Wiktionnaire,
Le dictionnaire libre*](https://fr.wiktionary.org/wiki/présentoir)

<p align=center>
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Cézy-FR-89-vide_grenier_2017-a3.jpg/360px-Cézy-FR-89-vide_grenier_2017-a3.jpg"/>
</p>


# Usage

```ruby
# Inherit from base class, then each class instace
# is "dumped" as a Hash, with every method as a key (and their return value)
# Private methods and those that take arguments wont be dumped.
class Presenter::Numbers < Presentoir::Presenter
  def one
    # plain values (skalars, Hashes, Arrays) are used as-is
    1
  end

  def random
    # when returning a Presenter, it will be recursivly dumped
    RandomNumber.new
  end
end

class Presenter::RandomNumber < Presentoir::Presenter
  def six_sided_dice
    roll_dice(6)
  end

  def eight_sided_dice
    roll_dice(8)
  end

  private

  def roll_dice(sides:)
    rand(sides - 1 ) + 1
  end
end

# use it:
data = Presenter::Numbers.new
# dump it:
data.dump
# => {:one=>1, :random=>{:six_sided_dice=>5, eight_sided_dice=>2}}}
# advanced: dump just parts of it:
data.dump(sparse_spec: {random: {eight_sided_dice: {}}}})
# => {:random=>{:eight_sided_dice=>4}}}
```
