using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class controller : MonoBehaviour
{
    public Material material;
    public Color insideColor;

    // public Vector2 pos;
    // public float scale, angle, smoothness, speed;

    private Vector2 pos;
    private float scale = 4;
    private float angle = 0;
    private float smoothness = 0.08f;
    private float speed = 0.01f;

    private Vector2 smoothPos;
    private float smoothScale, smoothAngle;

    private void shaderUpdate(){
        smoothPos = Vector2.Lerp(smoothPos, pos, smoothness);
        smoothScale = Mathf.Lerp(smoothScale, scale, smoothness);
        smoothAngle = Mathf.Lerp(smoothAngle, angle, smoothness);

        float aspectRatio = (float)Screen.width / (float)Screen.height;
        if(aspectRatio > 1f) material.SetVector("_Area", new Vector4(smoothPos.x,smoothPos.y,smoothScale,smoothScale / aspectRatio));
        else material.SetVector("_Area", new Vector4(smoothPos.x,smoothPos.y,smoothScale * aspectRatio,smoothScale));
        
        material.SetFloat("_Angle", smoothAngle);
        material.SetColor("_InColor", insideColor);
    }

    private void handleInputs(){
        if(Input.GetKey(KeyCode.Z)) scale *= .99f;
        if(Input.GetKey(KeyCode.S)) scale *= 1.01f;

        Vector2 direction;
        
        direction = new Vector2(speed * scale * Mathf.Cos(angle), speed * scale * Mathf.Sin(angle));
        if(Input.GetKey(KeyCode.LeftArrow)) pos -= direction;
        if(Input.GetKey(KeyCode.RightArrow)) pos += direction;

        direction = new Vector2(-speed * scale * Mathf.Sin(angle), speed * scale * Mathf.Cos(angle));
        if(Input.GetKey(KeyCode.UpArrow)) pos += direction;
        if(Input.GetKey(KeyCode.DownArrow)) pos -= direction;

        if(Input.GetKey(KeyCode.PageUp)) angle += speed;
        if(Input.GetKey(KeyCode.PageDown)) angle -= speed;
    }

    void Update()
    {
        handleInputs();
        shaderUpdate();
    }
}
