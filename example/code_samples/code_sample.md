!SLIDE

# Code Samples

Github Flavored Markdown

![octocat](../images/octocat.png)

!SLIDE

## Erlang

```erlang
Output = process(Input, []).

process([First|Rest], Output) ->
    NewFirst = do_stuff(First),
    process(Rest, [NewFirst|Output]);

process([], Output) ->
    lists:reverse(Output).
```