def is_leap(year):
    # Write your logic here
    # The year can be evenly divided by 4, is a leap year, unless:
    # The year can be evenly divided by 100, it is NOT a leap year, unless:
    # The year is also evenly divisible by 400. Then it is a leap year.
    return (year%4 == 0 and (year%400 == 0 or year%100 != 0))

year = int(raw_input())
print is_leap(year)