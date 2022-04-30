# Copyright 2022 XXIV
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import httpClient
import strformat
import strutils
import uri
import json

type
  Meal* = object
    idMeal* : string
    strMeal* : string
    strDrinkAlternate* : string
    strCategory* : string
    strArea* : string
    strInstructions* : string
    strMealThumb* : string
    strTags* : string
    strYoutube* : string
    strIngredient1* : string
    strIngredient2* : string
    strIngredient3* : string
    strIngredient4* : string
    strIngredient5* : string
    strIngredient6* : string
    strIngredient7* : string
    strIngredient8* : string
    strIngredient9* : string
    strIngredient10* : string
    strIngredient11* : string
    strIngredient12* : string
    strIngredient13* : string
    strIngredient14* : string
    strIngredient15* : string
    strIngredient16* : string
    strIngredient17* : string
    strIngredient18* : string
    strIngredient19* : string
    strIngredient20* : string
    strMeasure1* : string
    strMeasure2* : string
    strMeasure3* : string
    strMeasure4* : string
    strMeasure5* : string
    strMeasure6* : string
    strMeasure7* : string
    strMeasure8* : string
    strMeasure9* : string
    strMeasure10* : string
    strMeasure11* : string
    strMeasure12* : string
    strMeasure13* : string
    strMeasure14* : string
    strMeasure15* : string
    strMeasure16* : string
    strMeasure17* : string
    strMeasure18* : string
    strMeasure19* : string
    strMeasure20* : string
    strSource* : string
    strImageSource* : string
    strCreativeCommonsConfirmed* : string
    dateModified* : string

type
  Category* = object
    idCategory* : string
    strCategory* : string
    strCategoryThumb* : string
    strCategoryDescription* : string

type
  Ingredient* = object
    idIngredient* : string
    strIngredient* : string
    strDescription* : string
    strType* : string

type
  Filter* = object
    strMeal* : string
    strMealThumb* : string
    idMeal* : string

type
  MealDBException* = object of Exception

proc getRequest(endpoint: string): string =
  let client = newhttpClient()
  let response = client.request("https://themealdb.com/api/json/v1/1/" & endpoint, httpMethod = HttpGet)
  return response.body

proc search*(s: string): seq[Meal] =
  ## Search meal by name
  ##
  ## * `s` meal name
  ##
  ## Raises MealDBException
  try:
    let response = getRequest(fmt"search.php?s={encodeUrl(s)}")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["meals"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    var array: seq[Meal] = @[]
    for i in json["meals"]:
      array.add(to(i, Meal))
    return array
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())

proc searchByLetter*(c: char): seq[Meal] =
  ## Search meals by first letter
  ##
  ## * `c` meal letter
  ##
  ## Raises MealDBException
  try:
    let response = getRequest(fmt"search.php?f={c}")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["meals"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    var array: seq[Meal] = @[]
    for i in json["meals"]:
      array.add(to(i, Meal))
    return array
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())

proc searchById*(i: int): Meal =
  ## Search meal details by id
  ##
  ## * `i` meal id
  ##
  ## Raises MealDBException
  try:
    let response = getRequest(fmt"lookup.php?i={i}")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["meals"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let data = to(json["meals"][0], Meal)
    return data
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())

proc random*(): Meal =
  ## Search a random meal
  ##
  ## Raises MealDBException
  try:
    let response = getRequest("random.php")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["meals"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let data = to(json["meals"][0], Meal)
    return data
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())

proc mealCategories*(): seq[Category] =
  ## Search meal by name
  ##
  ## Raises MealDBException
  try:
    let response = getRequest("categories.php")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["categories"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    var array: seq[Category] = @[]
    for i in json["categories"]:
      array.add(to(i, Category))
    return array
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())

proc filterByIngredient*(s: string): seq[Filter] =
  ## Filter by ingredient
  ##
  ## * `s` ingredient name
  ##
  ## Raises MealDBException
  try:
    let response = getRequest(fmt"filter.php?i={encodeUrl(s)}")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["meals"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    var array: seq[Filter] = @[]
    for i in json["meals"]:
      array.add(to(i, Filter))
    return array
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())

proc filterByArea*(s: string): seq[Filter] =
  ## Filter by area
  ##
  ## * `s` area name
  ##
  ## Raises MealDBException
  try:
    let response = getRequest(fmt"filter.php?a={encodeUrl(s)}")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["meals"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    var array: seq[Filter] = @[]
    for i in json["meals"]:
      array.add(to(i, Filter))
    return array
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())

proc filterByCategory*(s: string): seq[Filter] =
  ## Filter by Category
  ##
  ## * `s` category name
  ##
  ## Raises MealDBException
  try:
    let response = getRequest(fmt"filter.php?c={encodeUrl(s)}")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["meals"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    var array: seq[Filter] = @[]
    for i in json["meals"]:
      array.add(to(i, Filter))
    return array
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())

proc categoriesFilter*(): seq[string] =
  ## List the categories filter
  ##
  ## Raises MealDBException
  try:
    let response = getRequest("list.php?c=list")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["meals"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    var array: seq[string] = @[]
    for i in json["meals"]:
      array.add(i["strCategory"].getStr)
    return array
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())

proc ingredientsFilter*(): seq[Ingredient] =
  ## List the ingredients filter
  ##
  ## Raises MealDBException
  try:
    let response = getRequest("list.php?i=list")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["meals"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    var array: seq[Ingredient] = @[]
    for i in json["meals"]:
      array.add(to(i, Ingredient))
    return array
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())

proc areaFilter*(): seq[string] =
  ## List the area filter
  ##
  ## Raises MealDBException
  try:
    let response = getRequest("list.php?a=list")
    if response.len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    let json = parseJson(response)
    if json["meals"].len == 0:
      raise MealDBException.newException("Something went wrong: Empty response")
    var array: seq[string] = @[]
    for i in json["meals"]:
      array.add(i["strArea"].getStr)
    return array
  except:
    raise MealDBException.newException(getCurrentExceptionMsg())
