Apirizer
=======

1. Include ```Apirizer::CanCanController``` into your API controller.

2. Inherit your decorator from ```Apirizer::Decorator```
and define there ```default_fieldset``` instance method.

3. Inherit CanCan ```Ability``` from ```Apirizer::Ability```
and leave it empty.

4. Define Protector ```protect``` blocks within your models.

5. ?????

6. PROFIT!
