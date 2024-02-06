from flask import Flask, request
import psycopg2
import json

app = Flask(__name__)

#définit les paramètres de connexion à la bdd
db_params =psycopg2.connect(database ="postgres",
                            host="127.0.0.1",
                            user="postgres",
                            password="toto",
                            port="8765")
db_params.autocommit=True
@app.route('/voitures', methods=['GET'])
def get_voitures():
    cursor = db_params.cursor()
    req = "SELECT * from voiture"
    cursor.execute(req)
    result=cursor.fetchall()
    print (result)
    cursor.close()
    return result


@app.route('/voiture', methods=['POST'])
def post_voiture():
    content_type=request.headers.get('Content-Type')
    if content_type=='application/json':
        body=request.json
        print(f"{body=}")
        if not all(key in body for key in ['name','price','quantity']):
            return "Missing required keys in json", 400
        cursor=db_params.cursor()
        req=f"INSERT INTO voiture (name, price, quantity) values (\'{body['name']}\',\'{body['price']}\',\'{body['quantity']}\')"
        cursor.execute(req)
        cursor.close()
        db_params.commit()
        cursor=db_params.cursor()
        req=f"SELECT id FROM voiture where name=\'{body['name']}\'"
        cursor.execute(req)
        result=cursor.fetchall()
        print(result)
        cursor.close()
        return result

@app.route('/voiture/<int:car_id>', methods=['PUT', 'DELETE'])
def put_delete_update(car_id):
    cursor=db_params.cursor()
    if request.method == 'PUT':
        content_type = request.headers.get('Content-type')
        if content_type == 'application/json':
            body = request.json
            put_query= f"UPDATE voiture SET {', '.join(f'{key}=%s' for key in body)} WHERE id = %s"
            cursor.execute(put_query, (*body.values(),car_id))
    elif request.method == 'DELETE':
        delete_query = "DELETE FROM voiture WHERE id = %s"
        cursor.execute(delete_query, (car_id,))

    db_params.commit()
    print(result)
    cursor.close()
    return f"Voture with id {car_id} put/delete successfully"

if __name__=='__main__':
    app.run(debug=True)
