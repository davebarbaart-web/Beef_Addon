[Skip to main content.](https://m2.material.io/components/chips#main_content)

Material 2 is no longer maintained. Upgrade to Material 3, the latest version of Material Design.

Learn about Material 3's Expressive components, dynamic color, adaptive design, and more

[arrow\_right\_alt\\
Use Material 3](https://m3.material.io/ "")

_menu_ [Material Design](https://m2.material.io/)

- [Design](https://m2.material.io/design "")
- [Components](https://m2.material.io/components "")
- [Develop](https://m2.material.io/develop "")
- [Resources](https://m2.material.io/resources "")
- [Blog](https://material.io/blog "")

_arrow\_back__search_ _close_

[Material Design](https://m2.material.io/ "logo")

Components

- [App bars: bottom](https://m2.material.io/components/app-bars-bottom "App bars: bottom")
- [App bars: top](https://m2.material.io/components/app-bars-top "App bars: top")
- [Backdrop](https://m2.material.io/components/backdrop "Backdrop")
- [Banners](https://m2.material.io/components/banners "Banners")
- [Bottom navigation](https://m2.material.io/components/bottom-navigation "Bottom navigation")
- [Buttons](https://m2.material.io/components/buttons "Buttons")
- [Buttons: floating action button](https://m2.material.io/components/buttons-floating-action-button "Buttons: floating action button")
- [Cards](https://m2.material.io/components/cards "Cards")
- [Checkboxes](https://m2.material.io/components/checkboxes "Checkboxes")
- [Chips](https://m2.material.io/components/chips "Chips")
- [Data tables](https://m2.material.io/components/data-tables "Data tables")
- [Date pickers](https://m2.material.io/components/date-pickers "Date pickers")
- [Dialogs](https://m2.material.io/components/dialogs "Dialogs")
- [Dividers](https://m2.material.io/components/dividers "Dividers")
- [Image lists](https://m2.material.io/components/image-lists "Image lists")
- [Lists](https://m2.material.io/components/lists "Lists")
- [Menus](https://m2.material.io/components/menus "Menus")
- [Navigation drawer](https://m2.material.io/components/navigation-drawer "Navigation drawer")
- [Navigation rail](https://m2.material.io/components/navigation-rail "Navigation rail")
- [Progress indicators](https://m2.material.io/components/progress-indicators "Progress indicators")
- [Radio buttons](https://m2.material.io/components/radio-buttons "Radio buttons")
- [Sheets: bottom](https://m2.material.io/components/sheets-bottom "Sheets: bottom")
- [Sheets: side](https://m2.material.io/components/sheets-side "Sheets: side")
- [Sliders](https://m2.material.io/components/sliders "Sliders")
- [Snackbars](https://m2.material.io/components/snackbars "Snackbars")
- [Switches](https://m2.material.io/components/switches "Switches")
- [Tabs](https://m2.material.io/components/tabs "Tabs")
- [Text fields](https://m2.material.io/components/text-fields "Text fields")
- [Time pickers](https://m2.material.io/components/time-pickers "Time pickers")
- [Tooltips](https://m2.material.io/components/tooltips "Tooltips")

# Chips

Chips are compact elements that represent an input, attribute, or action.

design\_servicesDesignintegration\_instructionsImplementation

Android Android _check_ Web  Flutter  iOS

Contents

- [Usage](https://m2.material.io/components/chips#usage)
- [Types](https://m2.material.io/components/chips#types)
- [Anatomy](https://m2.material.io/components/chips#anatomy)
- [Input chips](https://m2.material.io/components/chips#input-chips)
- [Choice chips](https://m2.material.io/components/chips#choice-chips)
- [Filter chips](https://m2.material.io/components/chips#filter-chips)
- [Action chips](https://m2.material.io/components/chips#action-chips)
- [Theming](https://m2.material.io/components/chips#theming)
- [Specs](https://m2.material.io/components/chips#specs)

![](https://lh3.googleusercontent.com/7Uie31xu_kvDNRQoA1ip8Rx8xDas1Pz97aRKXx2ACr4CUx0xjT23VQ2ooRGYUhQkJYaKixHXCfhb2hKsXZcwBwMU9Md34o9rdH0taTGgqvMy0rg7Y9g)

Material 3 chips are available

M3 chips have a boxier shape with rounded corners, more color mappings, and dynamic color compatibility. Action chips are further defined as assist or suggestion chips. Choice chips are a subset of filter chips.

- open\_in\_new[Chips in Material 3](https://m3.material.io/components/chips "Chips in Material 3")

![](https://lh3.googleusercontent.com/nIlSfsCutvqK4ZGO91rq9ktUX90a6t7zQhf7KFH-3RXL7gMcUDrLVFafgDr82PgnbiBuwLn8t1vvVcL66wHp9p5VYocPI-7fYb9w=w1064-v0)

Contents

- [Usage](https://m2.material.io/components/chips#usage)
- [Types](https://m2.material.io/components/chips#types)
- [Anatomy](https://m2.material.io/components/chips#anatomy)
- [Input chips](https://m2.material.io/components/chips#input-chips)
- [Choice chips](https://m2.material.io/components/chips#choice-chips)
- [Filter chips](https://m2.material.io/components/chips#filter-chips)
- [Action chips](https://m2.material.io/components/chips#action-chips)
- [Theming](https://m2.material.io/components/chips#theming)
- [Specs](https://m2.material.io/components/chips#specs)

* * *

## Usage _link_

Chips allow users to enter information, make selections, filter content, or trigger actions. While buttons are expected to appear consistently and with familiar calls to action, chips should appear dynamically as a group of multiple interactive elements.

### Principles

![](https://lh3.googleusercontent.com/pDL5J96qnIQ25zhj_aqUT4MEpLd-EAfujhsBazmWX-gBbdeCEP55qfaCwxlYPR8m7k4ItsZBVGXQHg_qWr_ZmFYN8DTEhWTD844ErOY=w1064-v0)

#### Compact

Chips are compact components that represent discrete information.

![](https://lh3.googleusercontent.com/8JN-ipmLNPYm0d4nYRgXAKsVc4anqr6nXXTL55KuCOHxN6aexCMzV-8JtT9__JmK7jpunC_i4JdWY9fz5qYeymhha9br6go4UmlmCQ0=w1064-v0)

#### Relevant

Chips should have a clear and helpful relationship to the content or task they represent.

![](https://lh3.googleusercontent.com/W-0oeo3PAdxcC5ptqawr_ewZ11ULAo2qO9dbo6Xji5m69foWxfRDIH5DcxL4diQqWyzuFjimOvDr-NQ_LRoR7yPsoFKl34aQ7bfxxCg=w1064-v0)

#### Focused

Chips should make tasks easier to complete, or content easier to sort.

* * *

## Types _link_

![](https://lh3.googleusercontent.com/3kBHtkifQVH38Go4YiE-UnMn7iJa64DrqE9YHGa6AkWOYHbq53FpS3xdbDyB0tBz_uHYlD72tp3ntqTtTDzMbmQ13MleRSv4HyMllQ=w1064-v0)

**Input chips**

Input chips represent information used in fields, such as an entity or different attributes.

![](https://lh3.googleusercontent.com/UrJF4iH25TiKmL5gpmk9_XJAoGrDsLPi2x0dWUvMlySy1iK4rAxcxkvl0eqctKrZwPov_mswMBTvP9WmMk_BEwg8CM7GtsdaS2RPhg=w1064-v0)

**Choice chips**

In sets that contain at least two options, choice chips represent a single selection.

![](https://lh3.googleusercontent.com/KKV--zzQ8NGIkk0Sto77a6XyJu-qL4__m9QFR0IZ3hb3zGD-kPEEhOz9eMR5_LiDofJHQqK5uSAi3ujWAjYFYStCETtzaciAFaL0=w1064-v0)

**Filter chips**

Filter chips represent filters for a collection.

![](https://lh3.googleusercontent.com/8v3BM76QBMCgXpSo5Zy-6cathzX8ecfVdOYNrW4Y16NmloMZwX2cbppn9uj5WwYHa36jpTdQ-yrNlF_vL6V3W60dALgUUTMfwduB2Q=w1064-v0)

**Action chips**

Action chips trigger actions related to primary content.

* * *

## Anatomy _link_

![](https://lh3.googleusercontent.com/Y2e1x4r3_CzYNxse_7M5CzUD6muqqF7pMskYKiLBubMLyTb1HiSGC6hKEP_9bZVf8AAkbznQJfhUkFgPxIBjkrHmw0G_FVj1bVDaEQ=w1064-v0)

**1\. Container** Chip containers hold all chip elements, and their size is determined by those elements. A container can also be defined by a stroke.

**2\. Thumbnail \[optional\]** Thumbnails identify entities (like individuals) by displaying an avatar, logo, or icon.

**3\. Text** Chip text can be an entity name, description, tag, action, or conversational.

**4\. Remove icon \[optional\]** Input chips can include a Remove icon.

* * *

## Input chips _link_

### Usage

Input chips represent a complex piece of information in compact form, such as an entity (person, place, or thing) or text. They enable user input...

Read more

Input chips represent a complex piece of information in compact form, such as an entity (person, place, or thing) or text. They enable user input and verify that input by converting text into chips.

![](https://lh3.googleusercontent.com/EgnGU7aPrk-pm8QjDUBITyWDHz_-5r2ZlYiMs0C2xtpVWgjzVRY5hlL2vmqQZs-faSD_93s_DoaG4dMeeDIzj7yFffzCx1s9zVwgaQ=w1064-v0)

An input chip used to show an entity.

![](https://lh3.googleusercontent.com/ChROsPpvJTKs2zKYp6IICuN85pjlUtEYBtyVoLoFp_YiP9s1Vvf9hphtXDHaTltom1-Lau6WsXHR3Q4ybHrLBRuwQ8O2Ok4Biaf0kmA=w1064-v0)

An outlined input chip used to show an entity.

![](https://lh3.googleusercontent.com/W8MjQ46DL6TL-17nbvD90euEDFuf1EI1qtGQrA5iQO78eCopavIYlMLA_Pif6pFowKT0na3UahTI9whzIOf_S_VDXNpRGXfDY0rX=w1064-v0)

Input chips can provide suggested responses.

* * *

### Behavior

Input chips are predictive, editable, movable, expandable, and appear in groups.

Read more

#### Transformative

Input chips transform text based on user input.

_volume\_off__volume\_off_

Mute

Unmute

Text transforming into an input chip.

#### Editable

An input chip’s text is editable until the user takes an action with the chip, such as sending an email. To edit an input chip’s text, tap the chip.

_volume\_off__volume\_off_

Mute

Unmute

Input chips become editable when tapped.

#### Informational

If text input is not recognized by the system, input chips can display an error state.

![](https://lh3.googleusercontent.com/mROaeX0mbxPtRRIDYQ3mTBLTGPgY0bjhzFC70h1mjLsbAn24W3NRY7jpAsDR8SZct2N-rBz0RngUVbSsJmJz2cmxBw99g7Ijp1cu8Q=w1064-v0)

Input chips can represent an error state.

#### Multiple

A single field can contain multiple input chips.

_volume\_off__volume\_off_

Mute

Unmute

Multiple entry chips

#### Movable

Input chips can be reordered or moved into other fields.

_volume\_off__volume\_off_

Mute

Unmute

Movable entry chips

#### Expandable

Input chips can expand to show more information or options. A container transform transition pattern is used to reveal additional content.

_volume\_off__volume\_off_

Mute

Unmute

Expandable entry chips

[Container transform\\
\\
For transitions between UI elements that include a container\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/motion/the-motion-system.html#container-transform "Container transform")

* * *

### Placement

Input chips work together with other UI elements.

Read more

Input chips can be integrated with other components. They can appear:

- Inline with the text input cursor in a field
- In a stacked list
- In a horizontally scrollable list

![](https://lh3.googleusercontent.com/HdUmHvYsb8wXeQQIPNhNjvdADB245LfRhnINT8I7WAwB5kIVozyDYfyg3QkIWIIrR1vyJsO6HrlEiQe7GFY_Nayx-ywmA_hpvwOV3g=w1064-v0)

Input chips can wrap to a new row if all of the chips need to be visible.

_volume\_off__volume\_off_

Mute

Unmute

Input chips that horizontally scroll.

[Anatomy\\
\\
An overlay is a semi-transparent covering on an element indicating state. Overlays allow for a systematic approach to visualizing states through opacity values.\\
\\
Related link _arrow\_downward_](https://m2.material.io/design/interaction/states.html#anatomy "Anatomy")

* * *

### States

Input chips states

Read more

![](https://lh3.googleusercontent.com/5B9KaLF0v3A3-b1GfUek3HDPYQj1fEnC3zmYJ3ILyK5t8Iuoz27_ftbmH7yBKGaYvjhoBj0JRENSczeubswR2VOlsTNmqcL1A7fF8TQ=w1064-v0)

![](https://lh3.googleusercontent.com/vql8XOpGEnrnW7PZxLecRn0pHtNQmOP_Co8z_LXjQWaJEmFbdQwi7IHYp56Yu3gkcJ_V_NXcAKLHeizRfV6qBCJmo_BS62uAdzryGQ8=w1064-v0)

Input chips states

* * *

## Choice chips _link_

### Usage

Choice chips allow selection of a single chip from a set of options. Choice chips clearly delineate and display options in a compact area. They...

Read more

Choice chips allow selection of a single chip from a set of options.

Choice chips clearly delineate and display options in a compact area. They are a good alternative to toggle buttons, radio buttons, and single select menus.

![](https://lh3.googleusercontent.com/MtI08ffQy-tuYjdBcgYA-WuJ_bJ0n0QcBZ9C60EfAu55neks_JsfxAysaGfxR713NbB2FluvPHujyA7nqATdzemXRUYqloKKLkVnmVU=w1064-v0)

A set of choice chips

![](https://lh3.googleusercontent.com/y9NbLEC9ih0YVw4NlPvwNoDYJ3bKph3Lo6XRAWZoarGuG1srYtrS24d08WReF5g7TDXxNn9tUfO1pF0Qjfe2n2xrPkIvy8OtKdFt=w1064-v0)

A set of outlined choice chips

[Toggle button\\
\\
Buttons allow users to take actions, and make selections, with a single tap.\\
\\
Related article _arrow\_downward_](https://m2.material.io/components/buttons#toggle-button "Toggle button")

[Radio buttons\\
\\
Radio buttons allow the user to select one option from a set.\\
\\
Related article _arrow\_downward_](https://m2.material.io/components/radio-buttons "Radio buttons")

[Menus\\
\\
Menus display a list of choices on temporary surfaces.\\
\\
Related article _arrow\_downward_](https://m2.material.io/components/menus "Menus")

* * *

### Behavior

Selecting a single choice chip automatically deselects all other chips in the set.

Read more

Selecting a single choice chip automatically deselects all other chips in the set.

_volume\_off__volume\_off_

Mute

Unmute

Selecting a choice chip deselects the other chips

* * *

### Placement

Choice chips appear as part of a series of other choice chips. They are typically displayed horizontally and sequentially. An overlay is a semi-transparent covering...

Read more

Choice chips appear as part of a series of other choice chips. They are typically displayed horizontally and sequentially.

![](https://lh3.googleusercontent.com/3OPdyhnjmthiihQv3Ak59yvFNvqQxyRx6QzwDvrlX2OlLLsSwzGOnkcbjsHG6U8V3sz-s89wC5VrkUfFtaWosOX4ITT0o2Ie5hsa=w1064-v0)

DoHorizontal placement of choice chips

![](https://lh3.googleusercontent.com/FJTpyuuL_-kOODhPpinp7T_lvAa-j8q1Pg_swLU7FlCGHvJOuNkLFhMRjEaSJhnlLIubbs6Do3fnbeAKWPqKl96oQOPhzD-S2bNw=w1064-v0)

DoChoice chips can scroll horizontally.

![](https://lh3.googleusercontent.com/iNk_ngVlwf0ZOGWaaREMMiqc5GL8SV76bmBKRqed4V2PIbXf7CK0ai7DOJhIERHCV-qiSVLIRaY7JZivTeG6b6kK1uoYVltzZw4XqA=w1064-v0)

CautionChoice chips can wrap to a new row. However, using two or more rows of choice chips can make each chip harder to scan.

![](https://lh3.googleusercontent.com/wyCgbjVJgY4r3g9CIghXaoBm1q5y00dIhkIrb6aTkSoz8zS6jymIr31pO1cyWTiGPWdran2hRFcz0Q6PzrpZRNts3EtcP7ppNJKTGA=w1064-v0)

Don'tChoice chips shouldn’t present only a single option.

[Anatomy\\
\\
An overlay is a semi-transparent covering on an element indicating state. Overlays allow for a systematic approach to visualizing states through opacity values.\\
\\
Related link _arrow\_downward_](https://m2.material.io/design/interaction/states.html#anatomy "Anatomy")

* * *

### States

Choice chips states

Read more

![](https://lh3.googleusercontent.com/prfvGYKhcevdV9NmN3F2ysROn_BP3HQhHv4FpScyskxoH1gR3UOkZivO44l6VI9_6tzK_jcGbfOmGrLVEMwqGqhgMxapNqQJDnTY=w1064-v0)

![](https://lh3.googleusercontent.com/SsgzltD_wxGKLtrA_bcGEEfVwQDfNHcAVhUTIQ9IoSuf8inOh8ZZEYpOKiP37em3ld1kmGBOfbrEvp9jNjKgL0U2sLx0IuH5Nv8U=w1064-v0)

Choice chips states

* * *

## Filter chips _link_

### Usage

Filter chips use tags or descriptive words to filter content. Filter chips clearly delineate and display options in a compact area. They are a good...

Read more

Filter chips use tags or descriptive words to filter content.

Filter chips clearly delineate and display options in a compact area. They are a good alternative to toggle buttons or checkboxes.

![](https://lh3.googleusercontent.com/YwR4por30NIiW1ldMOBMZaRxbeYLZY30Gqwa2MkktsLZ3AHc5TduSkNE8CCxkp0onXtTE4Cum5TCBkFfy3ThQNGWR-Oc5dDMtwuX=w1064-v0)

A filter chip

![](https://lh3.googleusercontent.com/v1nUhVhwLJb8WNUWxyWeitPCLrptxZ9gbtJ48cqEVWSKD5tZOIj0uJZQq0npDv5jzG4aESgAH9UHnpkKhXx6yzU0CmKaXUkfiBrL=w1064-v0)

An outlined filter chip

[Toggle button\\
\\
Buttons allow users to take actions, and make selections, with a single tap.\\
\\
Related article _arrow\_downward_](https://m2.material.io/components/buttons#toggle-button "Toggle button")

[Checkboxes\\
\\
Checkboxes allow the user to select one or more items from a set.\\
\\
Related article _arrow\_downward_](https://m2.material.io/components/selection-controls#checkboxes "Checkboxes")

* * *

### Behavior

Tap a chip to select it. Multiple chips can be selected or unselected.

Read more

Tap a chip to select it. Multiple chips can be selected or unselected.

_volume\_off__volume\_off_

Mute

Unmute

An icon can be added to indicate when a filter chip is selected.

_volume\_off__volume\_off_

Mute

Unmute

Filter chip suggestions can dynamically change as users start to select filters.

* * *

### Placement

Filter chips can live with other elements in a UI.

Read more

![](https://lh3.googleusercontent.com/F8OXOyPu5i9efHSd7XY5iSjXdRkZf-sn6DiO-rzRGix8TAzfNXV1drNqclbm_QuW8JJP3cXBycXLAGiimv9rfrGVAZ7scrsONqqboQ=w1064-v0)

Filter chips can be shown underneath a search field.

![](https://lh3.googleusercontent.com/Mv_1saeMeD4gCKPL6YUER5a2qVmCoOKgIyJv24L51264-cH05RrqlJUewBiXom9BCyf8TgmpK9LpzyNFoWLsh_PhJjVA4BaeTfiHp4s=w1064-v0)

Display multiple sets of filters in a side sheet.

![](https://lh3.googleusercontent.com/bUSptJ9Pn9Cng6FCgQ-ZY_zWqk0pr9GFz__Q9F7UY_yXOK5066eJX7iNmDjijjO4_aQGpJdXixWr0enJ-ST4w53P0Ki2RHbPbvJf3xA=w1064-v0)

Filter chips can wrap to a new row. If there are more than two rows, consider using horizontal scrolling to access them all.

![](https://lh3.googleusercontent.com/tWa0UhfJm-UStl7F5VnZkq2-ynFHpyZGzkGXyv02mgZ_ZXOWU-9tuArvF5BKFwXF4c7XodzzeciPrYLY0oAF3LJzMmx1Tp15qY4CNw=w1064-v0)

Filter chips can horizontally scroll to show unlimited options.

![](https://lh3.googleusercontent.com/xEA5myq4eNHtLl2HhWTYi2AQCBrNO8jGxaDcfSatWmMhE2hbdG3h10sVkFlr74oLwxxhYxrzLWB0jhKaRES97D-ordgaOVJ2xeXbVx0=w1064-v0)

Don'tFilter chips should not present only a single option.

[Side sheets\\
\\
Surfaces containing supplementary content that are anchored to the left or right edge of the screen.\\
\\
Related article _arrow\_downward_](https://m2.material.io/components/sheets-side#sheets-side "Side sheets")

[States\\
\\
Visual representations used to communicate the status of a component or interactive element.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/interaction/states.html "States")

* * *

### States

Choice chips states

Read more

![](https://lh3.googleusercontent.com/qwfWxVngEumkz4O5SpVOKSST93Miv8sUz5lVnE8nPHEdkoUfcjGz0z3rQcBGBwMF4MS7R6TdEZK33IG_p4ncoxt-EGSALa7sb-3pDBY=w1064-v0)

![](https://lh3.googleusercontent.com/_9nWwFxnoP831hEXXl1AdHmXSKUBNshPlWanKvkas7wKXfvwleyRF2z5UQTJaXYeEuBmkKEJuT9hInoos3XFf3emUy6Or5xx7XHAcA=w1064-v0)

Filter chips states

* * *

## Action chips _link_

### Usage

Action chips offer actions related to primary content. They should appear dynamically and contextually in a UI. An alternative to action chips are buttons, which...

Read more

Action chips offer actions related to primary content. They should appear dynamically and contextually in a UI.

An alternative to action chips are buttons, which should appear persistently and consistently.

![](https://lh3.googleusercontent.com/mzZZdJjKU_Dp41339HIl-ZHjDnkBO1ZAeunee8LO0evQDhMhhmAPhrnQWfwAKMWF2LXk33XRukGrCv0V2sOVK_O570OuR9bZUy-h=w1064-v0)

An action chip

![](https://lh3.googleusercontent.com/uLm9LJZsinEBiVW_pVT77kKZqbMjPTPncAdQX_1Vvz0B8mpn-luKmxB0hRJaDp5boXOa_IJJlFtT6i3QN6kXpcx8eVZVbIN18qmWUQ=w1064-v0)

An outlined action chip

[Contained button\\
\\
Buttons allow users to take actions, and make selections, with a single tap.\\
\\
Related article _arrow\_downward_](https://m2.material.io/components/buttons#contained-button "Contained button")

* * *

### Behavior

Action chips can trigger an action or show progress and confirmation.

Read more

Action chips can trigger an action or show progress and confirmation.

_volume\_off__volume\_off_

Mute

Unmute

Tapping an action chip triggers a contextual action.

_volume\_off__volume\_off_

Mute

Unmute

Action chips can show progress and confirmation feedback.

* * *

### Placement

Action chips are displayed after primary content, such as below a card or persistently at the bottom of a screen. Buttons allow users to take...

Read more

Action chips are displayed after primary content, such as below a card or persistently at the bottom of a screen.

![](https://lh3.googleusercontent.com/-zAq14gSDWOWyTwiegZd7YmkA_f9oMa8kQktsyYy7uW85-I4B8zCAr8ilxWR7YRBwDdI5AiPJmEZXjoBy0u0zKAQUXiRn8XCJLKsNw=w1064-v0)

Action chips should be shown underneath primary content.

![](https://lh3.googleusercontent.com/XBZM0_SAa0sY0D3m-DYqdD2h6p03DMx0nzLOMaKYoG3WgynFXcrEqqw6tRqbkHPEh-SsK9HYIk-nspZsjjQ4BiR8tOph-B_8l3zGNQ=w1064-v0)

CautionAction chips should appear in a set.

![](https://lh3.googleusercontent.com/kNkvykPnwHc63CCXYVbX87SA4mP6LM_aWEGINiXvkbQBkCn5SXxn1oFvsUiL7Yq6J_zyJ1fJ8F4QRwWHHYqJT7aqKvN4kCDD9MdhbCk=w1064-v0)

DoAction chips can be horizontally scrollable.

[Buttons\\
\\
Buttons allow users to take actions with a single tap.\\
\\
Related article _arrow\_downward_](https://m2.material.io/components/buttons "Buttons")

[States\\
\\
Visual representations used to communicate the status of a component or interactive element.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/interaction/states.html "States")

* * *

### States

Choice chips states

Read more

![](https://lh3.googleusercontent.com/n80hPoUm0O1v0KdHvnenq6bvKqhqfiZTl7Nj3kE_2TZ3hw2lGeISSY371mR2Cz85YDdpMXAB8NvgPONCm25WGJTnmacqFGPO94kMRA=w1064-v0)

![](https://lh3.googleusercontent.com/CPMWwYw13eyP6zzpLVlEjy75Pl_PmRTFUxod8-ZdwyvDhFZ50WCWF_Xwy63oubL1NM_XB5I9XL1rj58HUxISobyKMNbubVHYKHk=w1064-v0)

Action chips states

* * *

## Theming _link_

### Reply Material theme

This email app’s input chips have been customized using Material Theming. Areas of customization include color, typography, and shape. Reply is an email app that...

Read more

This email app’s input chips have been customized using Material Theming. Areas of customization include color, typography, and shape.

![](https://lh3.googleusercontent.com/puRcSsFMs6WlDzRfGU6DJn8UbOTv3WqD7n28ssHtAzEH5snuFZttsQWvb6ixg3mHMw-LbfUiO96EAmsz3Tqj48jL_u3NskGCrVgjJQ=w1064-v0)

Reply’s customized input chips

[Reply\\
\\
Reply is an email app that uses Material Design components and Material Theming to create an on-brand communication experience.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/material-studies/reply.html "Reply")

[The color system\\
\\
Create a color theme that reflects your brand or style\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/color/the-color-system.html "The color system")

[Applying color to UI\\
\\
In a UI, color has a variety of roles: from containing meaning, to expressing a look and feel.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/color/applying-color-to-ui.html "Applying color to UI")

#### Color

Reply’s input chips use custom color on two elements: text, container.

![](https://lh3.googleusercontent.com/zcxucAjea05CE6zBo_BcbC_K0HJwb0MCbX2Wi6fCERm_FmoT50KqECDypgqMg8SHMMTXy-7UJsq_P_Ws9o308dE53T9m-M-mIOiJzQ=w1064-v0)

| Element | Category | Attribute | Value |
| --- | --- | --- | --- |
| Text | On Surface | Color <br>Opacity | #232F34 <br>100% |
| Container | On Surface | Color <br>Opacity | #232F34 <br>12% |

[Understanding typography\\
\\
Typography is critical in establishing hierarchy and expressing brand presence that supports an effective digital experience.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/typography/understanding-typography.html "Understanding typography")

#### Typography

Reply’s input chips use custom typography for the text.

![](https://lh3.googleusercontent.com/12qTz6ZlyOhUM8FYOVUmKZtpCXqtVuVNK6cEHM3J8lwFyfhjxWBfFsmUttPovKJo6mcadNinHUSsxrAQ_fFoiiSa4FIaLV0iy4p7=w1064-v0)

| Element | Category | Attribute | Value |
| --- | --- | --- | --- |
| Text | Body 2 | Typeface<br>Font<br>Size<br>Case | Work Sans<br>Regular<br>15<br>Sentence case |

[About shape\\
\\
Direct attention, identify components, communicate state, and express brand\\
\\
Related link _arrow\_downward_](https://m2.material.io/design/shape/about-shape.html "About shape")

#### Shape

Reply’s input chip containers have custom corner shapes.

![](https://lh3.googleusercontent.com/hNoXOv392uY567x0N-l1A_M1U_vtixr7e00dXP4mvk2XMb12-aJYY5EI_BORJIvWPyxzcwJUsrhK3HLONyV32VjS8CK2NdYvKpUHZw=w1064-v0)

| Element | Category | Attribute | Value |
| --- | --- | --- | --- |
| Container | Small component | Family<br>Size | Rounded<br>50% |

* * *

### Shrine Material theme

Choice chips with customized shape, color, and typography.

Read more

This retail app’s choice chips have been customized using Material Theming. Areas of customization include color, typography, and shape.

![](https://lh3.googleusercontent.com/Ci0cV8V2JChbQpYShvxWx9khH17Zoh_esXyMa3UCh64n7y2aNhtpKqImTag7CRqX7zul_gyPIIF86oVvfC54DjJUrWVrdMjU0X8l=w1064-v0)

Shrine’s customized choice chips

[Shrine\\
\\
Shrine is a lifestyle and fashion brand that demonstrates how Material Design can be used in e-commerce.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/material-studies/shrine.html "Shrine")

[The color system\\
\\
Create a color theme that reflects your brand or style\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/color/the-color-system.html "The color system")

[Applying color to UI\\
\\
In a UI, color has a variety of roles: from containing meaning, to expressing a look and feel.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/color/applying-color-to-ui.html "Applying color to UI")

#### Color

Shrine’s choice chips use custom color on four elements: selected container, selected text, unselected container, and unselected text.

![](https://lh3.googleusercontent.com/QHxG5ze9o8L013t5ztP6Dhj4BVJ-B71p5KJ3KNgPX2W4r1wmmTszSsoGbiS8c3YRR395aE183CjLNkIaXcBM_GhbNj6O7sFmOM-4sw=w1064-v0)

| Element | Category | Attribute | Value |
| --- | --- | --- | --- |
| Selected container | Primary | Color<br>Opacity | #FEDBD0<br>100% |
| Selected text | On Primary | Color<br>Opacity | #442C2E<br>100% |
| Unselected text | On Surface | Color<br>Opacity | #442C2E<br>100% |
| Unselected container | On Surface | Color<br>Opacity | #442C2E<br>12% |

[Understanding typography\\
\\
Typography is critical in establishing hierarchy and expressing brand presence that supports an effective digital experience.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/typography/understanding-typography.html "Understanding typography")

#### Typography

Shrine’s choice chips use custom typography for the text.

![](https://lh3.googleusercontent.com/GmTGjda0uOHMpl4Jk47aDFiP2CgZ50GPLp2Y-B4qLUdWmmJbTs5jxPXPdtzEs1IAgIlZJy1FWCXqn7kCe5Ni9ubAE15yrTawuLQP=w1064-v0)

| Element | Category | Attribute | Value |
| --- | --- | --- | --- |
| Text | Body 2 | Typeface<br>Font<br>Size<br>Case | Rubik<br>Medium<br>14<br>Sentence case |

[About shape\\
\\
Direct attention, identify components, communicate state, and express brand\\
\\
Related link _arrow\_downward_](https://m2.material.io/design/shape/about-shape.html "About shape")

#### Shape

Shrine’s choice chip containers have custom corner shapes. Shrine’s chips use an override of the small component shape category family and size values.

![](https://lh3.googleusercontent.com/hAFAyVxK4GlvGR_qyvGD5AczjV8pw3VDdN1SdYBxN2y7L8IiAvN1-Upr1AzmmggcmYMv_xnAjGY-8JtFl_rvLpue7XkheoOl6HZV=w1064-v0)

| Element | Category | Attribute | Value |
| --- | --- | --- | --- |
| Container | Override\* | Family<br>Size | Rounded<br>4dp;4dp;4dp;4dp |

* * *

### Fortnightly Material theme

Filter chips with customized shape, color, and typography.

Read more

This news app’s filter chips have been customized using Material Theming. Areas of customization include color, typography, and shape.

![](https://lh3.googleusercontent.com/eOhMhzxTmsbrB7dsvrFBVxrYIjFsdtg6yTcpws7yd2kL6ZFSohHz5u_l_N6XJ7WqJRxQLphIboJZ6lRpIlhyFN0pQoBwRVsW6U1XbvU=w1064-v0)

Fortnightly’s customized filter chips.

[Fortnightly\\
\\
A news app that uses Material Design components and Material Theming to create an on-brand, content-focused experience.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/material-studies/fortnightly.html "Fortnightly")

[The color system\\
\\
Create a color theme that reflects your brand or style\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/color/the-color-system.html "The color system")

[Applying color to UI\\
\\
In a UI, color has a variety of roles: from containing meaning, to expressing a look and feel.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/color/applying-color-to-ui.html "Applying color to UI")

#### Color

Fortnightly’s filter chips use custom color on two elements: text, and container stroke.

![](https://lh3.googleusercontent.com/0NdFquTa0fG3WONVKSd8sQN07XArw-l0vc5TdmAfKzLMSZwM7o1R8o8JfmOdvVkxEi2Oyt9fWIlWCJbavH97-lJtilJ1eIGa6Qjs0Aw=w1064-v0)

| Element | Category | Attribute | Value |
| --- | --- | --- | --- |
| Text | On Surface | Color<br>Opacity | #000000<br>87% |
| Container stroke | On Surface | Color<br>Opacity | #000000<br>12% |

[Understanding typography\\
\\
Typography is critical in establishing hierarchy and expressing brand presence that supports an effective digital experience.\\
\\
Related article _arrow\_downward_](https://m2.material.io/design/typography/understanding-typography.html "Understanding typography")

#### Typography

Fortnightly’s filter chips use custom typography for the text.

![](https://lh3.googleusercontent.com/KamCn1NNqJIIW5fkqq3-fWfPUU6cf1DVAwDZANgu59VPrFoc5EQwYFGJ99r_3cEmUrSQKU2jDqIFzKpashfRI_TZTirji_SQU0ED=w1064-v0)

| Element | Category | Attribute | Value |
| --- | --- | --- | --- |
| Text | Body 2 | Typeface<br>Font<br>Size<br>Case | Libre Franklin<br>Regular<br>14<br>Title case |

[About shape\\
\\
Direct attention, identify components, communicate state, and express brand\\
\\
Related link _arrow\_downward_](https://m2.material.io/design/shape/about-shape.html "About shape")

#### Shape

Fortnightly’s filter chip containers have custom corner shapes, with 0dp cut corners.

![](https://lh3.googleusercontent.com/ZjFVtu7QFk19Ym3jcl9qRd5z2NTPAkYiqgZ8Is4EneoXNrqe3yj_guE_Zt7W8D3hJ1lG8pBMnMaraql8fvTIOUfjpfz78ieUlEgEDQ=w1064-v0)

| Element | Category | Attribute | Value |
| --- | --- | --- | --- |
| Container | Small component | Family<br>Size | Cut<br>0dp;0dp;0dp;0dp |

* * *

## Specs _link_

#### Action chip

- 32  Measurement 32
- 12  Measurement 12
- 12  Measurement 12
- C  Measurement C

- [Roboto ![Google Fonts](https://storage.googleapis.com/spec-host/mio-staging/mio-components/1581631970573/static/m2/images/font-logo.svg)](https://fonts.google.com/specimen/Roboto)

14dp



#000000de


- #0000001f



R0 G0 B0 A0.12


- Shape

All corners



Rounded: 16dp

- [Elevation _open\_in\_new_](https://m2.material.io/environment/elevation.html#default-elevations)

Elevation



0dp


![](https://storage.googleapis.com/spec-host-backup/mio-components%2Fassets%2F1wT5tTIVacbicVoJeQ52O6EdcpHOtpfVB%2Fspecs-chips-action.png)

_flip_ Specs only available at larger screen size

#### Outlined action chip

- 4  Measurement 4
- 12  Measurement 12
- 8  Measurement 8
- 1  Measurement 1
- 32  Measurement 32
- 24  Measurement 24
- C  Measurement C

- [Elevation _open\_in\_new_](https://m2.material.io/environment/elevation.html#default-elevations)

Elevation



0dp

- Shape

All corners



Rounded: 16dp


![](https://storage.googleapis.com/spec-host-backup/mio-components%2Fassets%2F1ViXjQ0VVbUTCWxYszJUt4t3xajmIgBR-%2Fspecs-outlined-chips-action.png)

_flip_ Specs only available at larger screen size

#### \#\#\#\# Choice chip          - 12  Measurement 12  - 12  Measurement 12  - 32  Measurement 32  - C  Measurement C      - [Roboto ![Google Fonts](https://storage.googleapis.com/spec-host/mio-staging/mio-components/1581631970573/static/m2/images/font-logo.svg)](https://fonts.google.com/specimen/Roboto)     14dp          \#000000de        - \#0000001f          R0 G0 B0 A0.12        - Shape    All corners          Rounded: 16dp    - [Elevation _open\_in\_new_](https://m2.material.io/environment/elevation.html\#default-elevations)     Elevation          0dp        ![](https://storage.googleapis.com/spec-host-backup/mio-components%2Fassets%2F1LgVZMCD2CAQW9l6qr5ZEuCTGZr6KCS1x%2Fspecs-chips-choice.png)            _flip_ Specs only available at larger screen size

#### \#\#\#\# Filter chip          - 12  Measurement 12  - C  Measurement C  - 32  Measurement 32  - 12  Measurement 12      - [Roboto ![Google Fonts](https://storage.googleapis.com/spec-host/mio-staging/mio-components/1581631970573/static/m2/images/font-logo.svg)](https://fonts.google.com/specimen/Roboto)     14dp          \#000000de        - \#0000001e          R0 G0 B0 A0.12        - Shape    All corners          Rounded: 16dp    - [Elevation _open\_in\_new_](https://m2.material.io/environment/elevation.html\#default-elevations)     Elevation          0dp        ![](https://storage.googleapis.com/spec-host-backup/mio-components%2Fassets%2F1b952ZIVr9YKj47n6GAVckgMgSM53ULH4%2Fspecs-chips-filter.png)            _flip_ Specs only available at larger screen size

#### \#\#\#\# Input chips          - 4dp  Measurement 4dp  - 8  Measurement 8  - 8  Measurement 8  - 32  Measurement 32  - C  Measurement C  - 24  Measurement 24  - 18  Measurement 18  - 8  Measurement 8      - [Roboto ![Google Fonts](https://storage.googleapis.com/spec-host/mio-staging/mio-components/1581631970573/static/m2/images/font-logo.svg)](https://fonts.google.com/specimen/Roboto)     14dp          \#000000de        - \#0000001f          R0 G0 B0 A0.12        - [Elevation _open\_in\_new_](https://m2.material.io/environment/elevation.html\#default-elevations)     Elevation          0dp    - Shape    All corners          Rounded: 16dp        ![](https://storage.googleapis.com/spec-host-backup/mio-components%2Fassets%2F1nygxUm01qpHU0krNdV--zwTsgcDZeEeG%2Fspecs-chips-input.png)            _flip_ Specs only available at larger screen size

#### Chips in groups

- 8  Measurement 8

- [Roboto ![Google Fonts](https://storage.googleapis.com/spec-host/mio-staging/mio-components/1581631970573/static/m2/images/font-logo.svg)](https://fonts.google.com/specimen/Roboto)

14dp



#000000de


- #0000001f



R0 G0 B0 A0.12


- Shape

All corners



Rounded: 16dp

- [Elevation _open\_in\_new_](https://m2.material.io/environment/elevation.html#default-elevations)

Elevation



0dp


![](https://storage.googleapis.com/spec-host-backup/mio-components%2Fassets%2F1PMwNpp8Ow45ChuqAjkhUXPvHlNbZXL4s%2Fspecs-chipsingrous.png)

_flip_ Specs only available at larger screen size

Contents

- [Usage](https://m2.material.io/components/chips#usage)
- [Types](https://m2.material.io/components/chips#types)
- [Anatomy](https://m2.material.io/components/chips#anatomy)
- [Input chips](https://m2.material.io/components/chips#input-chips)
- [Choice chips](https://m2.material.io/components/chips#choice-chips)
- [Filter chips](https://m2.material.io/components/chips#filter-chips)
- [Action chips](https://m2.material.io/components/chips#action-chips)
- [Theming](https://m2.material.io/components/chips#theming)
- [Specs](https://m2.material.io/components/chips#specs)

## Using chips _link_

Before you can use Material chips, you need to add a dependency to the Material
Components for Android library. For more information, go to the
[Getting started](https://github.com/material-components/material-components-android/tree/master/docs/getting-started.md "")
page.

Chips allow users to enter information, make selections, filter content, or
trigger actions. While buttons are expected to appear consistently and with
familiar calls to action, chips should appear dynamically as a group of multiple
interactive elements.

### Usage

A Chip can be added in a layout like so:

```
xxxxxxxxxx
```

Changes to a chip can be observed like so:

```
xxxxxxxxxx
```

### Making chips accessible

Chips support content labeling for accessibility and are readable by most screen
readers, such as TalkBack. Text rendered in chips is automatically provided to
accessibility services. Additional content labels are usually unnecessary.

#### Touch target

The Widget.MaterialComponents.Chip.\* styles use an
[InsetDrawable](https://developer.android.com/reference/android/graphics/drawable/InsetDrawable "")
to extend the chip's touch target when necessary to meet Android's recommended
[accessibility touch target size](https://support.google.com/accessibility/android/answer/7101858 "").
Developers can override a chip's minimum touch target size using
app:chipMinTouchTargetSize. Developers can set whether the chip should extend
its bounds to meet the minimum touch target using app:ensureMinTouchTargetSize
(true by default).

#### RTL-friendly chip layout

Call setLayoutDirection(int) with View.LAYOUT\_DIRECTION\_LOCALE to ensure
that the chip's ancestor TextView renders the text with proper paddings.
Without this, the initial rendering may look like the text has its padding set
according to LTR direction.

```
xxxxxxxxxx
```

### Grouping chips with ChipGroup

Chips are mostly commonly used in groups. We recommend using ChipGroup as it
is purpose-built to handle multi-chip layout and behavior patterns (as opposed
to a ViewGroup such as RecyclerView). A ChipGroup contains a set of
Chips and manages their layout and multiple-exclusion scope, similarly to a
RadioGroup.

#### Layout Mode

A ChipGroup rearranges chips across multiple rows by default.

!["6 grey "Filter" chips spread across 2 lines: "Filters" 1 and 3 selected and are darker grey and include checkmarks."](https://lh3.googleusercontent.com/hv5x-7G5m3KEgI990ix5_PZTstGIDZwrTOTHpo-qJDUKRtNhT-LhCzU74jUVlh3ihrG0Wj2dG2Ie_10eQamcUrPyIHHihh9IresB0o5FzyNVtYctSEM=w1064-v0)

```
xxxxxxxxxx
```

A ChipGroup can also constrain its chips to a single row using the
app:singleLine attribute. Using a single row may necessitate wrapping the
ChipGroup with a HorizontalScrollView.

!["Single line of grey chips: chips 1, 2, and 3 are fully visible, chip 4 is partly visible"](https://lh3.googleusercontent.com/e4FPyVJXO08ynMTAsRXfOb-UpIH03Gnn6DP8PBP5FKem2luZfDcpJG6IwOoUactr0PwSfl116FK1UHfhkjHBmOMouT0HA8d-TWEZaHTkRZ93MW4bGMq0=w1064-v0)

```
xxxxxxxxxx
```

#### Chip spacing

A ChipGroup can insert spacing between chips in a row or between rows of chips
using the app:chipSpacing attribute. Different horizontal and vertical spacing
can be set using the app:chipSpacingHorizontal and app:chipSpacingVertical
attributes.

_**Note:** The app:chipMinTouchTargetSize will overrule vertical chip spacing_
_for lower amounts._

The following image shows a group of chips with
app:chipSpacingHorizontal="42dp".

!["6 grey chips in 2 rows with 42dp horizontal spacing"](https://lh3.googleusercontent.com/NxY2eUqDu0fn8Bv4P6bjGLarGSLzpxkKRo3onSYcshgxpMZVC2OANvh1_PswEmKEiRRQvmLBsszLq6lHIenQrZNOd_duEtVwR-KmU1Arek8D9f6w5s0=w1064-v0)

#### Multiple exclusion scope

The app:singleSelection attribute can be set to true on a ChipGroup in order
to toggle single-select and multi-select behavior of child chips.

The app:selectionRequired attribute can be set to true on a ChipGroup to
prevent all child chips from being deselected (i.e. at least one option should
be chosen).

#### Handling checked chips

Changes to child chip checked/unchecked state can be observed like so:

```
xxxxxxxxxx
```

### Standalone ChipDrawable

A standalone ChipDrawable can be used in contexts that require a Drawable.
The most obvious use case is in text fields that "chipify" contacts, commonly
found in communications apps.

To use a ChipDrawable, first create a chip resource in res/xml. Note that
you must use the <chip tag in your resource file.

In res/xml/standalone\_chip.xml:

```
xxxxxxxxxx
```

Entry Chip is the default Material style for standalone ChipDrawables, but you
can apply any of the other styles using the style attribute. All the
attributes on Chip can be applied to a ChipDrawable resource.

A ChipDrawable can then be inflated from this resource like so:

```
xxxxxxxxxx
```

For example, consider an editable e-mail address field that converts addresses
to chips as they are typed and validated. We can combine ChipDrawable with
spans to add a chip to an EditText:

!["Standalone chip inside a text field"](https://lh3.googleusercontent.com/MVmhub46n2MjtXKh6e-_BdNkXG-8gW3elxlpADar2gbQgku59xcNcvurSY12Ad8ZVjYuUbgr2jUe23WU8wNF564CsejG5jsn8s5umSPEbKzuzj9AGHI=w1064-v0)

```
xxxxxxxxxx
```

### Types

There are four types of chips: 1. [input (entry)](https://m2.material.io/components/chips#input-chip ""), 2.
[choice](https://m2.material.io/components/chips#choice-chip ""), 3\. [filter](https://m2.material.io/components/chips#filter-chip ""), 4\. [action](https://m2.material.io/components/chips#action-chip "")

![Examples of the four different chip types](https://lh3.googleusercontent.com/BeGBFSWcl3WMPNmBOqldtXrfbvFbMa0gbYBVIPkCmBcFuodNlS8nK1vdpe5I7p1zaCQlxey960X7ybtI752vTAqzYqhQav2ZjQtPqBIZtzSzJ1gt5Q=w1064-v0)

API and source code:

- Chip
  - [Class definition](https://developer.android.com/reference/com/google/android/material/chip/Chip "")
  - [Class source](https://github.com/material-components/material-components-android/tree/master/lib/java/com/google/android/material/chip/Chip.java "")
- ChipGroup
  - [Class definition](https://developer.android.com/reference/com/google/android/material/chip/ChipGroup "")
  - [Class source](https://github.com/material-components/material-components-android/tree/master/lib/java/com/google/android/material/chip/ChipGroup.java "")
- ChipDrawable
  - [Class definition](https://developer.android.com/reference/com/google/android/material/chip/ChipDrawable "")
  - [Class source](https://github.com/material-components/material-components-android/tree/master/lib/java/com/google/android/material/chip/ChipDrawable.java "")

## Input chip _link_

Input chips (refered to as **entry** chips in Android) represent a complex piece
of information in compact form, such as an entity (person, place, or thing) or
text. They enable user input and verify that input by converting text into
chips.

### Input chip example

The following example shows three input chips.

!["Input chips with texts Input 1 to 3."](https://lh3.googleusercontent.com/toxhh9qcEHe8iQs0kfgFO63yokUY3ayMm3hdODUYKAG3nAZtw508h1aWxtiZ26ehRvovm85LDxGHabDCAm7TZRE85VBHC9LjmQgFV2UzYS1czs5WoWA=w1064-v0)

In the layout:

```
xxxxxxxxxx
```

## Choice chip _link_

Choice chips allow selection of a single chip from a set of options.

Choice chips clearly delineate and display options in a compact area. They are a
good alternative to toggle buttons, radio buttons, and single select menus.

### Caveats

If you add choice chips to a dialog (which has 24dp elevation), disable the
chips' elevation overlays to ensure that there is sufficient color contrast when
the chips are checked.

```
xxxxxxxxxx
```

### Choice chip example

The following example shows four choice chips.

!["4 choice chips, Choice 1 is selected with purple fill, Choices 2-4 unselected with grey fill"](https://lh3.googleusercontent.com/cSdrVwkBztGWT7WMLS_RDunassnSrMHxfg6dzxBG8aVhurf9GVGghLVYRbY_9_0xSx3y1cl2xqlAi2rN2ElLHKf5U43-ZIot5bIvk_A_u10KzToVQEE=w1064-v0)

In the layout:

```
xxxxxxxxxx
```

## Filter chip _link_

Filter chips use tags or descriptive words to filter content.

Filter chips clearly delineate and display options in a compact area. They are a
good alternative to toggle buttons or checkboxes.

### Filter chip example

The following example shows six filter chips.

!["6 grey "Filter" chips spread across 2 lines: "Filters" 1 and 3 selected and are darker grey and include checkmarks."](https://lh3.googleusercontent.com/Bg4MPYNrpHAdHxFmGDFzLtaZvb7P6PiOL1ki_v7IaNt9oL1jmI38_kCz5Na0dVBAmqKJCKuu7jIAGquH6DXDsTKmHbagvdRYUxlVfXH9DN25fJA-yp0=w1064-v0)

In the layout:

```
xxxxxxxxxx
```

## Action chip _link_

Action chips offer actions related to primary content. They should appear
dynamically and contextually in a UI.

An alternative to action chips are buttons, which should appear persistently and
consistently.

### Action chip example

The following example shows four action chips.

!["Actions chips with texts Action 1 to 4 and icons."](https://lh3.googleusercontent.com/DggNyOFdPhA1w_GmoUJuKfDPEKRwrVM-NtiyIjM6xvTRlyS74Xy1r3CVREXjyEeOyQh3GC_HBdCZllHaPaYMj1E1iIxjxifU_EyAt8L9Rdvd6tOGqg2d=w1064-v0)

In the layout:

```
xxxxxxxxxx
```

### Anatomy and key properties

The following is an anatomy diagram of a chip:

![Chip anatomy diagram](https://lh3.googleusercontent.com/FUPNdWfK2ZrL-FHaMJT-ZqMlmndiZRf7GF1VF61c6vf12HCPT1NjC9wwYAmHtz3h9qkv1TpuxyuiXCGrCeEjM0TDotVUhb5uJr8EufNaYzx-un6hv9Rp=w1064-v0)

1. Container
2. Thumbnail (optional)
3. Text
4. Remove icon (optional)

#### Container attributes

| Element | Attribute | Related method(s) | Default value |
| --- | --- | --- | --- |
| **Color** | app:chipBackgroundColor | setChipBackgroundColor<br>setChipBackgroundColorResource<br>getChipBackgroundColor | ?attr/colorOnSurface at 10% |
| **Ripple color** | app:rippleColor | setRippleColor<br>setRippleColorResource<br>getRippleColor | ?attr/colorOnSurface at 12% |
| **Stroke width** | app:chipStrokeWidth | setStrokeWidth<br>setChipStrokeWidthResource<br>getChipStrokeWidth | 0dp |
| **Stroke color** | app:chipStrokeColor | setStrokeColor<br>setChipStrokeColorResource<br>getChipStrokeColor | ?attr/colorOnSurface |
| **Min height** | app:chipMinHeight | setChipMinHeight<br>setChipMinHeightResource<br>getChipMinHeight | 32dp |
| **Padding** | app:chipStartPadding<br>app:chipEndPadding | setChip\*Padding<br>setChip\*PaddingResource<br>getChip\*Padding | 4dp (start)<br>6dp (end) |
| **Shape** | app:shapeAppearance<br>shapeAppearanceOverlay | setShapeAppearanceModel<br>getShapeAppearanceModel | ?attr/shapeAppearanceSmallComponent with 50% cornerSize |
| **Min touch target** | app:chipMinTouchTargetSize<br>app:ensureMinTouchTargetSize | ensureAccessibleTouchTarget<br>setEnsureAccessibleTouchTarget<br>shouldEnsureAccessibleTouchTarget | 48dp<br>true |
| **Checkable** | android:checkable | setCheckable<br>setCheckableResource<br>isCheckable | true (entry, filter, choice) |

#### Thumbnail attributes

**Chip icon**

| Element | Attribute | Related method(s) | Default value |
| --- | --- | --- | --- |
| **Icon** | app:chipIcon | setChipIconVisible<br>isChipIconVisible | null |
| **Visibility** | app:chipIconVisible | setChipIcon<br>setChipIconResource<br>getChipIcon | true (action and entry) |
| **Color** | app:chipIconTint | setChipIconTint<br>setChipIconTintResource<br>getChipIconTint | null |
| **Size** | app:chipIconSize | setChipIconSize<br>setChipIconSizeResource<br>getChipIconSize | 24dp |
| **Padding** | app:iconStartPadding<br>app:iconEndPadding | setIcon\*Padding<br>setIcon\*PaddingResource<br>getIcon\*Padding | 0dp |

**Checked icon**

If visible, the checked icon overlays the chip icon.

| Element | Attribute | Related method(s) | Default value |
| --- | --- | --- | --- |
| **Icon** | app:checkedIcon | setCheckedIconVisible<br>isCheckedIconVisible | @drawable/ic\_mtrl\_chip\_checked\_circle |
| **Visibility** | app:checkedIconVisible | setCheckedIcon<br>setCheckedIconResource<br>getCheckedIcon | true (entry, filter, choice) |
| **Color** | app:checkedIconTint | setCheckedIconTint<br>setCheckedIconTintResource<br>getCheckedIconTint | null |

#### Text attributes

| Element | Attribute | Related method(s) | Default value |
| --- | --- | --- | --- |
| **Text label** | android:text | setChipText<br>setChipTextResource<br>getChipText | null |
| **Color** | android:textColor | setTextColor<br>getTextColors | ?attr/colorOnSurface at 87% |
| **Typography** | android:textAppearance | setTextAppearance<br>setTextAppearanceResource<br>getTextAppearance | ?attr/textAppearanceBody2 |
| **Padding** | app:textStartPadding<br>app:textEndPadding | setText\*Padding<br>setText\*PaddingResource<br>getText\*Padding | 8dp (start)<br>6dp (end) |

#### Remove (close) icon attributes

| Element | Attribute | Related method(s) | Default value |
| --- | --- | --- | --- |
| **Icon** | app:closeIcon | setCloseIcon<br>setCloseIconResource<br>getCloseIcon | @drawable/ic\_mtrl\_chip\_close\_circle |
| **Visibility** | app:closeIconVisible | setCloseIconVisible<br>isCloseIconVisible | true for entry |
| **Color** | app:closeIconTint | setCloseIconTint<br>setCloseIconTintResource<br>getCloseIconTint | ?attr/colorOnSurface at 87% |
| **Size** | app:closeIconSize | setCloseIconSize<br>setCloseIconSizeResource<br>getCloseIconSize | 18dp |
| **Padding** | app:closeIconStartPadding<br>app:closeIconEndPadding | setCloseIcon\*Padding<br>setCloseIcon\*PaddingResource<br>getCloseIcon\*Padding | 2dp |
| **Content description** | N/A | setCloseIconContentDescription<br>getCloseIconContentDescription | @string/mtrl\_chip\_close\_icon\_content\_description |

#### ChipGroup attributes

| Element | Attribute | Related method(s) | Default value |
| --- | --- | --- | --- |
| **Layout** | app:singleLine | setSingleLine<br>isSingleLine | false |
| **Selection** | app:singleSelection<br>app:selectionRequired | setSingleSelection\*<br>isSingleSelection\* | false<br>false |
| **Spacing** | app:chipSpacing<br>app:chipSpacingHorizontal<br>chipSpacingVertical | setSpacing\*<br>setChipSpacing\*Resource<br>getSpacing\* | 8dp |

#### Styles

| Element | Style |
| --- | --- |
| **Default style (action chip)** | Widget.MaterialComponents.Chip.Action |
| **Input (entry) chip** | Widget.MaterialComponents.Chip.Entry |
| **Choice chip** | Widget.MaterialComponents.Chip.Choice |
| **Filter chip** | Widget.MaterialComponents.Chip.Filter |
| **ChipGroup style** | Widget.MaterialComponents.ChipGroup |

#### Theme attributes

| Element | Theme attribute | Default style |
| --- | --- | --- |
| **Chip** | ?attr/chipStyle | Widget.MaterialComponents.Chip.Action |
| **ChipGroup** | ?attr/chipGroupStyle | Widget.MaterialComponents.ChipGroup |
| **ChipDrawable** | ?attr/chipStandaloneStyle | Widget.MaterialComponents.Chip.Entry |

See the full list of
[styles](https://github.com/material-components/material-components-android/tree/master/lib/java/com/google/android/material/chip/res/values/styles.xml "")
and
[attributes](https://github.com/material-components/material-components-android/tree/master/lib/java/com/google/android/material/chip/res/values/attrs.xml "").

## Theming chips _link_

Chips support [Material Theming](https://m2.material.io/components/chips/#theming "")
and can be customized in terms of color, typography and shape.

### Chip theming example

API and source code:

- Chip
  - [Class definition](https://developer.android.com/reference/com/google/android/material/chip/Chip "")
  - [Class source](https://github.com/material-components/material-components-android/tree/master/lib/java/com/google/android/material/chip/Chip.java "")
- ChipGroup
  - [Class definition](https://developer.android.com/reference/com/google/android/material/chip/ChipGroup "")
  - [Class source](https://github.com/material-components/material-components-android/tree/master/lib/java/com/google/android/material/chip/ChipGroup.java "")
- ChipDrawable
  - [Class definition](https://developer.android.com/reference/com/google/android/material/chip/ChipDrawable "")
  - [Class source](https://github.com/material-components/material-components-android/tree/master/lib/java/com/google/android/material/chip/ChipDrawable.java "")

The following example shows chips with Material Theming.

!["3 chips with brown text and icons, white fill, and pink outlines"](https://lh3.googleusercontent.com/GaN5uT266nHPXTDLxspQ2Jk_El-Zvo2gHt_NDvaqXHpWxG-27opb61zBtx7MVpSnVWk56sbEdkF6-1EANotL1ZFF0gujpxaEKLKC_FAdG7AJYbE-Ww8=w1064-v0)

#### Implementing chip theming

Using theme attributes and styles in res/values/styles.xml (themes all chips
and affects other components):

```
xxxxxxxxxx
```

in color/stroke\_tint.xml:

```
xxxxxxxxxx
```

or using a default style theme attribute, styles and a theme overlay (themes all
chips but does not affect other components):

```
xxxxxxxxxx
```

or using the style in the layout (affects only this specific chips):

```
xxxxxxxxxx
```

No Android implementation guidance available

## Using chips _link_

Chips are compact elements that allow users to enter information, select a choice, filter content, or trigger an action. Chips must always be used inside a chip set.

### Installing chips

```
xxxxxxxxxx
```

### Styles

```
xxxxxxxxxx
```

### JavaScript instantiation

```
xxxxxxxxxx
```

## Chips _link_

Chips are comprised of [chip sets](https://www.github.com/material-components/material-components-web/tree/v12.0.0/packages/mdc-chips/chip-set "") which are comprised of [chip](https://www.github.com/material-components/material-components-web/tree/v12.0.0/packages/mdc-chips/chip "") instances which are in turn comprised of [actions](https://www.github.com/material-components/material-components-web/tree/v12.0.0/packages/mdc-chips/action ""). See the readme for each subcomponent for more detail.

### Basic action chip set example

```
xxxxxxxxxx
```

## API _link_

See the readme of each subcomponent for more detail.

- [Chip set API](https://www.github.com/material-components/material-components-web/tree/v12.0.0/packages/mdc-chips/chip-set "")
- [Chip API](https://www.github.com/material-components/material-components-web/tree/v12.0.0/packages/mdc-chips/chip "")
- [Action API](https://www.github.com/material-components/material-components-web/tree/v12.0.0/packages/mdc-chips/action "")

### Usage within frameworks

If you are using a JavaScript framework, such as React or Angular, you can create chips for your framework. Depending on your needs, you can use the _Simple Approach: Wrapping MDC Web Vanilla Components_, or the _Advanced Approach: Using Foundations and Adapters_. Please follow the instructions [here](https://www.github.com/material-components/material-components-web/tree/v12.0.0/packages/mdc-chips/docs/integrating-into-frameworks.md "").

No Web implementation guidance available

## Using chips _link_

Chips allow users to enter information, make selections, filter content, or trigger actions. While buttons are expected to appear consistently and with familiar calls to action, chips should appear dynamically as a group of multiple interactive elements.

### Making chips accessible

Flutter's APIs support accessibility setting for large fonts, screen readers, and sufficient contrast. For more information, go to Flutter's [accessibility](https://flutter.dev/docs/development/accessibility-and-localization/accessibility "") and [internationalization](https://flutter.dev/docs/development/accessibility-and-localization/internationalization "") pages.

### Types

There are four different types of chips that are subclasses of [Chip](https://api.flutter.dev/flutter/material/Chip-class.html ""), including 1.[input](https://m2.material.io/components/chips#input-chips ""), 2.[choice](https://m2.material.io/components/chips#choice-chips ""), 3.[filter](https://m2.material.io/components/chips#filter-chips ""), and 4.[action](https://m2.material.io/components/chips#action-chips "").

![Examples of the four different chip types](https://lh3.googleusercontent.com/0i3N2xe6uBzq8_vY_sSdaazVb_3RZBTNcJ0ViP9871MkHcvh7KV3lamaqN0tVQBdXfCE9spWGEnegMVdwJntKdnxg8NoBge3-IqkUFNyiKB22vxO6MY=w1064-v0)

### Anatomy and key properties

The following is an anatomy diagram of a chip:

![Chip anatomy diagram](https://lh3.googleusercontent.com/9BvnvVfXX9Z6X7U8LMA6WFzFvIgd0v8oo58KM1An5tyBZisnqMUeTTovT45iy9x7d4UJaf_WP7mSPmAoQE8DN0ZkFqV1Jn6TRAHu3RJgAXvTXDoajuc=w1064-v0)

1. Container
2. Thumbnail (optional)
3. Text
4. Remove icon (optional)

### Container

|  | Property |
| --- | --- |
| **Height** | padding |

### Thumbnail

|  | Property |
| --- | --- |
| **avatar** | avatar |
| **border** | avatarBorder |

### Text

|  | Property |
| --- | --- |
| **Text label** | label and use Text widget |
| **Color** | label and use Text widget within textWidget set style |
| **Typography** | label and use Text widget within textWidget set style |
| **padding** | labelPadding |

### Remove icon

|  | Property |
| --- | --- |
| **color** | deleteIconColor |

## Input chips _link_

Input chips represent a complex piece of information in compact form, such as an entity (person, place, or thing) or text. They enable user input and verify that input by converting text into chips.

### Input chips example

InputChip

- [Class definition](https://api.flutter.dev/flutter/material/InputChip-class.html "")
- [GitHub source](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/chip.dart "")
- [Dartpad demo](https://dartpad.dev/embed-flutter.html?gh_owner=material-components&gh_repo=material-components-flutter&gh_path=docs/components/dartpad/chips/input&gh_ref=develop "")

![Input Chips](https://lh3.googleusercontent.com/d3EyI7Ls8UERa82S0MWpdwNh1gLZ1j9BUyrYMvjLE1xdjd6T8qFMpw37RSxOg1qFM8pIybS3yJfZOEA2CQ_u9FRC2Fia0Qbw4CSQYEFsKsR6KIpodF8=w1064-v0)

```
xxxxxxxxxx
```

## Choice chips _link_

Choice chips allow selection of a single chip from a set of options.

Choice chips clearly delineate and display options in a compact area. They are a good alternative to toggle buttons, radio buttons, and single select menus.

### Choice chips example

ChoiceChip

- [Class definition](https://api.flutter.dev/flutter/material/ChoiceChip-class.html "")
- [GitHub source](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/chip.dart "")
- [Dartpad demo](https://dartpad.dev/embed-flutter.html?gh_owner=material-components&gh_repo=material-components-flutter&gh_path=docs/components/dartpad/chips/choice&gh_ref=develop "")

![Choice Chips](https://lh3.googleusercontent.com/liWlyrd_fI3l70Sx2tRFS7537zSyOGz0WOmkhHveuYUMNKOQR3ZvHJXjFh6qhP4KElYbjaJ52hIkOYCZTgB2CS-EzuWCmv7S9YSYQiSeQq2l-AspoW8=w1064-v0)

```
xxxxxxxxxx
```

## Filter chips _link_

Filter chips use tags or descriptive words to filter content.

Filter chips clearly delineate and display options in a compact area. They are a good alternative to toggle buttons or checkboxes.

### Filter chips example

FilterChip

- [Class definition](https://api.flutter.dev/flutter/material/FilterChip-class.html "")
- [GitHub source](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/chip.dart "")
- [Demo site](https://dartpad.dev/embed-flutter.html?gh_owner=material-components&gh_repo=material-components-flutter&gh_path=docs/components/dartpad/chips/filter "")

![Filter Chips](https://lh3.googleusercontent.com/AJ2-S4RVFHFG5wjDf00zUuOJuR9v6AGVbvYC_PdPS9Q28rymA-sPhJTUpfi5FqV5c1_KUg4cNcndBKaQQ7s018r_jfMS-UFJvllMj9w1uo_5y3_GcGE=w1064-v0)

```
xxxxxxxxxx
```

## Action chips _link_

Action chips offer actions related to primary content. They should appear dynamically and contextually in a UI.

An alternative to action chips are buttons, which should appear persistently and consistently.

### Action chips example

ActionChip

- [Class definition](https://api.flutter.dev/flutter/material/ActionChip-class.html "")
- [GitHub source](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/chip.dart "")
- [Demo site](https://dartpad.dev/embed-flutter.html?gh_owner=material-components&gh_repo=material-components-flutter&gh_path=docs/components/dartpad/chips/action "")

![Action Chips](https://lh3.googleusercontent.com/WQihZl6t2EAJ0c3l_BPhMomIHMm7g6tOIOrtv9q4GTt76wCXY9M3JNJY2zoYVR5W5eK4tUTo3c5uf__Frqde1DxVlkQ4pDt0S7ZLsVyznfWq1Fm0vbI=w1064-v0)

```
xxxxxxxxxx
```

## Theming _link_

Chips support [Material Theming](https://m2.material.io/components/chips/#theming "") and can be customized in terms of color, typography and shape.

### Theming example

InputChip

- [Class definition](https://api.flutter.dev/flutter/material/InputChip-class.html "")
- [GitHub source](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/chip.dart "")
- [Demo site](https://dartpad.dev/embed-flutter.html?gh_owner=material-components&gh_repo=material-components-flutter&gh_path=docs/components/dartpad/chips/theme "")

![Theme Chips](https://lh3.googleusercontent.com/YAKiJ6XOapsuU7DmOZx2sZpYCkZyjapfL7B7rqnhvKCpbwniwuIxrJSvg6OEVL3fbQWMfixkYgq-ae9Qskgz3gn6fF3Q-mkBQwiTPJKwsoy6bpCuPHo=w1064-v0)

```
xxxxxxxxxx
```

No Flutter implementation guidance available

As of July 15 2021, Material's iOS libraries are in maintenance mode. [Learn more](https://github.com/material-components/material-components-ios/#material-components-for-ios).

## Using chips _link_

### Installing

To use chips in your app first add the following to your Podfile:

```
xxxxxxxxxx
```

Then, run the following command:

```
xxxxxxxxxx
```

From there, import the relevant target or file.

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

### Making chips accessible

Always verify that your chips meet minimum touch requirements, as defined by either Apple's Human Interface Guidelines or Material. Material recommends a 44x44 minimum touch target.

Remember to set any relevant accessibilityLabels or accessibilityTraits, especially if you are not satisfied with default system-assigned values.

**Types**

There are four types of chips: 1. [Input (text entry)](https://m2.material.io/components/chips#input-chip "") 2\. [Choice](https://m2.material.io/components/chips#choice-chip "") 3\. [Filter](https://m2.material.io/components/chips#filter-chip "") 4\. [Action](https://m2.material.io/components/chips#action-chip "")

![Examples of the four different chip types](https://lh3.googleusercontent.com/0gYxh4zEXNsqddvDaH3tPgawfgnNuzm-k526KtEfIiSOWG-RbFvQOLGHKGwdPqKz2ps8wXs0wR1RxF2Cpr_u4yUSEQ1hsCcoDaz6w1u8JixpfZbJ6Kz6=w1064-v0)

It is possible to create each type of chip by instantiating a single MDCChipView and adidng it to your view controller just like any other UIView.

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

MDCChipView allows for customization of the following:

### Ink ripple animation

Chips display animated ink splashes when the user presses the chip. Note that if you have a background color set for the highlighted state the ink animation will occur on top of that color.

### Stateful properties

Like UIButton, MDCChipView provides many state-dependant accessors. These methods allow you to set the background color, title
color, border style, and elevation, both for individual states and combinations of states. If no value is set for a given state, the normal value will used.

### Selected Image View

Setting the image for the selectedImageView is optional but can help clarify that a chip is selected. This image will only appear when the chip is selected. If you have an
image set on the standard imageView, then the selectedImageView will appear on top of it. Otherwise
you'll need to resize the chip to show the selected image. See the Filter chip example to see this
in action.

### Padding

There are 4 padding properties that determine a chip's layout: one for each of the chip's
subviews (imageView and selectedImageView share one padding property), and one which wraps all
the others (contentPadding). This is useful so that you can set each of the padding properties to
ensure your chips look correct whether or not they have an image and/or accessory view. The chip
uses these property to determine intrinsicContentSize and sizeThatFits.

### Adjusting chip sizes after changing the label

If the label of a chip in a collection view can be changed dynamically (e.g. in reaction to a user's
tap), then you may notice that the chip's frame does not automatically update to accomodate the new
size of the chip's label. To force your chip to update its layout when this happens you can invoke
invalidateIntrinsicContentSize on the chip view. For example:

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

## Input chip _link_

Input chips represent a complex piece of information in compact form, such as an entity (person, place, or thing) or text. They enable user input and verify that input by converting text into chips.

We provide an implementation of Input Chips called MDCChipField.

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

## Choice chip _link_

Choice chips allow selection of a single chip from a set of options.

Choice chips clearly delineate and display options in a compact area. They are a good alternative to toggle buttons, radio buttons, and single select menus.

It is easiest to create choice Chips using a UICollectionView:

- Use MDCChipCollectionViewFlowLayout as the UICollectionView layout:

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

- Leave the default UICollectionView selection setting (single selection).
- Use MDCChipCollectionViewCell as UICollectionView cells. (MDCChipCollectionViewCell manages the state of the chip based on selection state of UICollectionView automatically)

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

- Use UICollectionViewDelegate methods collectionView:didSelectItemAtIndexPath: for reacting to new choices.

- Use UICollectionViewselectItemAtIndexPath:animated:scrollPosition: method to edit choice selection programmatically.


## Filter chip _link_

Filter chips use tags or descriptive words to filter content.

Filter chips clearly delineate and display options in a compact area. They are a good alternative to toggle buttons or checkboxes.

It is easiest to create filter Chips using a UICollectionView:

- Use MDCChipCollectionViewFlowLayout as the UICollectionView layout:

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

- Allow multi cell selection in the UICollectionView:

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

- Use MDCChipCollectionViewCell as UICollectionView cells. (MDCChipCollectionViewCell manages the state of the chip based on selection state of UICollectionView automatically)

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

- Use UICollectionViewDelegate methods collectionView:didSelectItemAtIndexPath: and collectionView:didDeselectItemAtIndexPath: for reacting to filter changes.

- Use UICollectionViewdeselectItemAtIndexPath:animated: and selectItemAtIndexPath:animated:scrollPosition: methods to edit filter selection in code.


## Action chip _link_

Action chips offer actions related to primary content. They should appear dynamically and contextually in a UI.

An alternative to action chips are buttons, which should appear persistently and consistently.

It is easiest to create action Chips using a UICollectionView:

- Use MDCChipCollectionViewFlowLayout as the UICollectionView layout:

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

- Leave the default UICollectionView selection setting (single selection).
- Use MDCChipCollectionViewCell as UICollectionView cells. (MDCChipCollectionViewCell manages the state of the chip based on selection state of UICollectionView automatically)

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

- Make sure that MDCChipCollectionViewCell does not stay in selected state

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

- Use UICollectionViewDelegate method collectionView:didSelectItemAtIndexPath: to Trigger the action.

### Anatomy and key properties

The following is an anatomy diagram of a chip:

![Chip anatomy diagram](https://lh3.googleusercontent.com/8cu73t85I7pltFLvkfqNi9vTPHRw2XpQ7rHNxXt_GJEFHyg6JhQxR0XqzfPgIQ84l4Zm_iObmRC9cxuZVAp21NwvRfg5JcMjkOLPJEuMVqHtISCtCZw=w1064-v0)

1. Container
2. Thumbnail (optional)
3. Text
4. Remove icon (optional)

#### Container attributes

|  | Attribute | Related method(s) | Default value |
| --- | --- | --- | --- |
| **Color** | N/A | -setBackgroundColor:forState:<br>-backgroundColorForState: | On surface color at 12% opacity |
| **Ripple color** | N/A | -setRippleColor:forState:<br>-rippleColorForState: | White at 14% opacity |
| **Stroke width** | N/A | -setBorderWidth:forState:<br>-borderWidthForState: | 0 |
| **Stroke color** | N/A | -setBorderColor:forState:<br>-borderColorForState: | nil |
| **Min height** | minimumSize | N/A | { 0, 32 } |
| **Padding** | contentPadding | N/A | { 4, 4, 4, 4 } |
| **Min touch target** | centerVisibleArea, visibleAreaInsets | N/A | NO, { 0, 0, 0, 0 } |

#### Thumbnail attributes

**Chip icon**

|  | Attribute | Related method(s) | Default value |
| --- | --- | --- | --- |
| **Icon** | imageView, selectedImageView | N/A | nil |
| **Padding** | imagePadding, accessoryPadding | N/A | { 0, 0, 0, 0 }, { 0, 0, 0, 0 } |

#### Text attributes

|  | Attribute | Related method(s) | Default value |
| --- | --- | --- | --- |
| **Text label** | titleLabel | N/A | N/A |
| **Color** | N/A | -setTitleColor:forState:<br>-titleColorForState: | On surface color at 87% opacity |
| **Typography** | titleFont | N/A | Body 2 |
| **Padding** | titlePadding | N/A | { 3, 8, 4, 8 } |

## Theming _link_

MDCChipView supports Material Theming using a Container Scheme. To install the MDCChipView theming extension, first add the following line to your Podfile:

```
xxxxxxxxxx
```

Then run the installer:

```
xxxxxxxxxx
```

There are two theming variants for MDCChipView: the default theme and the outlined theme.

Below is a Chip collection with the Shrine outlined theme applied to it.

![shrine-chips](https://lh3.googleusercontent.com/80T2MFCn9RcYSPwjpJD9JaGfWzwCfLI9YtQtvWpq-GmtESwsNwtHIawGSMNRhBNtuciF0O34Q_Y1pMKLJ-2rOX7KnuCaOr99p7eUgFZdgb-En_1vVyY=w1064-v0)

swiftobjective-c

#### Swift

```
xxxxxxxxxx
```

#### Objective-C

```
xxxxxxxxxx
```

No iOS implementation guidance available

## Up next

[**Components**  **Data tables**](https://m2.material.io/components/data-tables "Data tables")[**Components**  **Buttons**](https://m2.material.io/components/buttons "Buttons")[**Components**  **Buttons: floating action button**](https://m2.material.io/components/buttons-floating-action-button "Buttons: floating action button")

Material is an adaptable system of guidelines, components, and tools that support the best practices of user interface design. Backed by open-source code, Material streamlines collaboration between designers and developers, and helps teams quickly build beautiful products.

- [GitHub](https://www.github.com/material-components)
- [Twitter](https://www.twitter.com/materialdesign)
- [YouTube](https://www.youtube.com/materialdesign)
- [Blog RSS](https://m2.material.io/feed.xml)
- [Material 3](https://m3.material.io/)

- [Privacy Policy](https://policies.google.com/privacy)
- [Terms of Service](https://policies.google.com/terms)
- [License](https://www.apache.org/licenses/LICENSE-2.0.html)
- Feedback